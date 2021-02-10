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
  CREATE_LINK = "#{ENV['JUGENDAPP_URL']}/api/ji/jobboard/check-user"

  include ConfirmToggle
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
  after_create :create_rc_account
  after_update :create_rc_account


  after_create :send_create_to_jugendinfo
  after_update :send_update_to_jugendinfo
  after_destroy :send_delete_to_jugendinfo

  attr_accessor :assigned_to_region, :region_id

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
    if self.rc_id.blank?
      env = ""
      env = "dev" if Rails.env == "development"
      rc = RocketChat::Users.new
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
        self.save
      else
        Rails.logger.error rc.error
        false
      end
    else
      true
    end
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
      mail = Notifier.weekly_update_for_broker(broker)
      mail.deliver unless mail.nil?
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
        mobile: self.mobile_was,
        new_mobile: self.mobile,
        email: self.email_was,
        new_email: self.email,
        rc_id: self.rc_id,
        rc_username: self.rc_username
    }
  end

  # Make post request to jugendinfo API
  #
  def send_to_jugendinfo(method)
    if ENV['JI_ENABLED']
      begin
        logger.info "Sending changes to jugendinfo #{CURRENT_LINK}"
        data = { operation: method }
        data.merge!(jugendinfo_data)
        # response = RestClient.post CURRENT_LINK, data, {Authorization: "Bearer #{ENV['JUGENDAPP_TOKEN']}"}
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
    send_to_jugendinfo("UPDATE")
  end
  # Make post request to jugendinfo API
  #
  def send_create_to_jugendinfo
    if ENV['JI_ENABLED']
      begin
        logger.info "Sending create to jugendinfo #{CREATE_LINK}"
        data = { phone: mobile, email: email }
        response = RestClient.post CREATE_LINK, data, {Authorization: "Bearer #{ENV['JUGENDAPP_TOKEN']}"}
        logger.info "Response from jugendinfo: #{response}"
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
  def send_delete_to_jugendinfo
    send_to_jugendinfo("DELETE")
  end
end
