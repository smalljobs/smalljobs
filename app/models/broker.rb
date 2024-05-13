class Broker < ActiveRecord::Base

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :registerable, authentication_keys: [:email]

  ROLES = [:normal, :organization_admin, :region_admin]
  ROLES_HASH =  {
      normal: I18n.t('broker.normal', locale: :de, default: 'Vermittlung'),
      organization_admin: I18n.t('broker.organization_admin', locale: :de, default: 'Organisationsadministration'),
      region_admin: I18n.t('broker.region_admin', locale: :de, default: 'Regionsadministration'),
      blocked: I18n.t('broker.blocked', locale: :de, default: 'Deaktiviert')
  }

  CURRENT_LINK = "#{ENV['JUGENDAPP_URL']}/api/ji/jobboard/sync"
  CHECK_LINK = "#{ENV['JUGENDAPP_URL']}/api/ji/jobboard/check-user"

  include ConfirmToggle
  include Auditable
  include Storext.model

  has_and_belongs_to_many :update_prefs
  has_many :employments, inverse_of: :broker
  has_many :organizations, through: :employments
  has_many :regions, through: :employments
  has_many :places, through: :regions
  has_many :providers, through: :places
  has_many :seekers, through: :places
  has_many :jobs, through: :providers
  has_many :assignments, through: :providers
  has_many :notes
  has_many :unread_messages
  has_many :broadcast_messages
  # organization method is used, uses different logic
  # belongs_to :organization, foreign_key: :default_broker_id
  validates :email, email: true, presence: true, uniqueness: true
  validates :firstname, :lastname, :phone, presence: true
  validates :phone, :mobile, phony_plausible: true
  validates :role, presence: true

  validate :unique_email
  validate :unique_mobile

  phony_normalize :phone, default_country_code: 'CH'
  phony_normalize :mobile, default_country_code: 'CH'

  store_attributes :settings do
    selected_organization_id Integer, default: 0
    filter String, default: ''
  end

  after_create :connect_to_region

  before_create :get_rc_account_from_ji
  after_create :create_rc_account_and_save
  before_update :create_rc_account

  after_create :send_create_to_jugendinfo
  after_update :send_update_to_jugendinfo
  after_destroy :send_delete_to_jugendinfo

  attr_accessor :assigned_to_region, :region_id, :ji_request

  def connect_to_region
    if assigned_to_region == 'true'
      employment = Employment.new(broker_id: self.id, region_id: region_id)
      employment.assigned_only_to_region = true
      employment.save
    end
  end

  def organization
    self.organizations.first
  end

  ROLES.each do |role|
    #normal?, region_admin?, :organization_admin?
    define_method("#{role}?") do
      self.role == role.to_s
    end
  end

  def all_organizations
    all_org = []
    regions.each do |region|
      region.organizations.where(active: true).each do |organization|
        all_org.append(organization) if all_org.find_index(organization).nil?
      end
    end

    all_org.sort_by &:name
  end

  # Check if there is no seeker or provider with the same email
  #
  def unique_email
    seeker = Seeker.find_by(email: email)
    provider = Provider.find_by(email: email)
    if !seeker.nil? || !provider.nil?
      errors.add(:email, :email_not_unique)
    end
  end

  def unique_mobile
    return if mobile.blank?
    seeker = Seeker.find_by(mobile: mobile)
    provider = Provider.find_by(mobile: mobile)
    if !seeker.nil? || !provider.nil?
      errors.add(:mobile, :mobile_not_unique)
    end
  end

  def create_rc_account
    if ENV['ROCKET_CHAT_URL'].present?
      rc = RocketChat::Users.new
      if self.rc_id.blank?
        user_rc_details = rc.find_user_by_email(email)
      else
        user_rc_details = nil
      end
      if self.rc_id.blank? and user_rc_details.blank?
        env = ""
        env = "dev" if Rails.env == "development"

        user = rc.create({
                      name: self.name,
                      email: self.email,
                      username: "smalljobs_#{env}#{self.id}",
                      password: SecureRandom.hex,
                      verified: true,
                      customFields: {
                        smalljobs_user_id: self.id,
                        is_support_user: "No"
                      }
                  })
        if user
          self.rc_id = user[:user_id]
          self.rc_username = user[:user_name]
        else
          Rails.logger.error rc.error
          false
        end
      elsif self.rc_id.blank? and user_rc_details.present?
        self.rc_id = user_rc_details[:rc_id]
        self.rc_username = user_rc_details[:rc_username]
      else
        true
      end
    else
      true
    end
  end

  def create_rc_account_and_save
    self.create_rc_account
    self.save
  end

  def create_rc_token
    rc = RocketChat::Users.new
    if self.rc_id.present?
      answer = rc.create_token(self.rc_id)
      if answer
        return answer[:auth_token]
      else
        Rails.logger.error "Can not get Broker rc_token #{rc.error}"
        nil
      end
    else
      Rails.logger.error "Broker does not have a rc_id"
      nil
    end
  end

  def get_rc_account_from_ji
    if ENV['JI_ENABLED']
      response = {}
      data = {}
      data.merge!({phone: mobile}) if mobile.present?
      data.merge!({email: email}) if email.present?
      data.merge!({ type: 'broker' })
      if data.present?
        begin
          response = RestClient.post CHECK_LINK, data, { Authorization: "Bearer #{ENV['JUGENDAPP_TOKEN']}" }
        rescue RestClient::ExceptionWithResponse => e
          e.response
        end
      end
      if response.present? and JSON.parse(response.body)['result'] == true
        record = JSON.parse(response.body)
        self.rc_id = record["user"]["chat_user_id"]
        self.rc_username = record["user"]["chat_user_username"]
        self.app_user_id = record["user"]["id"]
      end
    end
    true
  end

  # Returns the display name
  #
  # @return [String] the name
  #
  def name
    "#{firstname} #{lastname}"
  end

  # @!group Devise

  # Check if the user can log in
  #
  # @return [Boolean] the status
  #
  def active_for_authentication?
    active?
  end

  # Return the I18n message key when authentication fails
  #
  # @return [Symbol] the i18n key
  #
  def unauthenticated_message
    confirmed? ? :inactive : :unconfirmed
  end

  def self.send_weekly_update
    today = Date.today()
    day_of_week = today.wday
    update_pref = UpdatePref.find_by(day_of_week: day_of_week)
    BrokersUpdatePref.where(update_pref_id: update_pref.id).find_each do |broker_update_pref|
      broker = broker_update_pref.broker
      next unless broker.active?
      begin
        mail = Notifier.weekly_update_for_broker(broker)
        mail.deliver unless mail.nil?
      rescue StandardError => e
        Rails.logger.info "Error occurs when sending weekly update. Broker.send_weekly_update"
        Rails.logger.info e.inspect
      end
    end
  end

  def unread_messages_hash
    array = self.unread_messages.where("quantity > 0").map do |unread_message|
        [unread_message.seeker_id , unread_message.quantity]
    end.flatten
    return Hash[*array]
  end

  def unread_messages_sum
    self.unread_messages.sum(:quantity)
  end

  def update_unread_messages
    timestampt = DateTime.now - 1.minutes
    seeker_messages = []
    if self.unread_messages_timestamp.present?
      seeker_messages = RocketChat::Users.new().unread_seekers(self.rc_id, self.unread_messages_timestamp)
      self.update(unread_messages_timestamp: timestampt)
    else
      seeker_messages = RocketChat::Users.new().unread_seekers(self.rc_id)
      self.update(unread_messages_timestamp: timestampt)
    end

    seeker_messages = [] if seeker_messages == false

    seeker_messages.each do |k,v|
      v = v.to_i
      seeker = Seeker.find_by_rc_username(k)
      if seeker.present?
        unread_message = UnreadMessage.where(broker_id: self.id, seeker_id: seeker.id)
        if unread_message.present?
          unread_message.update(quantity: v)
        else
          UnreadMessage.create(broker_id: self.id, seeker_id: seeker.id, quantity: v)
        end
      end
    end

  end

  # @!endgroup

  private

  def jugendinfo_data
    # ApiHelper::seeker_to_json(self)
    {
      broker_id: self.id,
      # phone: self.phone_was,
      # new_phone: self.phone,
      mobile: self.mobile_was || self.mobile,
      new_mobile: self.mobile,
      email: self.email_was || self.email,
      new_email: self.email,
      rc_id: self.rc_id,
      rc_username: self.rc_username
    }
  end

  # Make post request to jugendinfo API
  #
  def send_to_jugendinfo(method)
    if ENV['JI_ENABLED'] and self.ji_request != true
      begin
        logger.info "Sending changes to jugendinfo #{CURRENT_LINK}"
        data = { operation: method }
        data.merge!(jugendinfo_data)
        puts data
        response = RestClient.post CURRENT_LINK, data, {Authorization: "Bearer #{ENV['JUGENDAPP_TOKEN']}"}
        #logger.info "Response from jugendinfo: #{response}"
      rescue RestClient::ExceptionWithResponse => e
        logger.info e.response
        logger.info "Failed sending changes to jugendinfo"
        raise ActiveRecord::Rollback, "Failed sending changes to jugendinfo"
      rescue Exception => e
        logger.info e.inspect
        logger.info "Failed sending changes to jugendinfo"
        raise ActiveRecord::Rollback, "Failed sending changes to jugendinfo"
      end
    end
  end

  # Make post request to jugendinfo API
  #
  def send_update_to_jugendinfo
    if self.app_user_id.present?
      send_to_jugendinfo("UPDATE")
    end
  end
  # Make post request to jugendinfo API
  #
  def send_create_to_jugendinfo
    # if self.app_user_id.present?
    #   send_to_jugendinfo("CREATE")
    # end
  end
  # Make post request to jugendinfo API
  #
  def send_delete_to_jugendinfo
    if self.app_user_id.present?
      send_to_jugendinfo("DELETE")
    end
  end
end
