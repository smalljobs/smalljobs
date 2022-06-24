class Seeker < ActiveRecord::Base
  require 'rest-client'

  devise :database_authenticatable, :registerable, authentication_keys: [:login]

  CURRENT_LINK = "#{ENV['JUGENDAPP_URL']}/api/ji/jobboard/sync"
  CHECK_LINK = "#{ENV['JUGENDAPP_URL']}/api/ji/jobboard/check-user"

  attr_accessor :is_register

  # include ConfirmToggle
  include Auditable

  enum status: {inactive: 1, active: 2, completed: 3}

  has_and_belongs_to_many :work_categories
  has_and_belongs_to_many :certificates

  has_many :allocations, dependent: :destroy
  has_many :assignments, dependent: :destroy
  has_many :access_tokens, as: :userable, dependent: :destroy
  # has_many :notes

  has_many :jobs, through: :allocations
  has_many :providers, through: :jobs

  has_one :jobs_certificate

  has_many :todos, dependent: :destroy

  belongs_to :place, inverse_of: :seekers
  belongs_to :organization
  has_one :region, through: :place

  attr_accessor :new_note
  attr_accessor :current_broker_id, :ji_request

  validates :login, presence: true, uniqueness: true

  validates :firstname, :lastname, presence: true

  validates :street, :place, presence: true

  validates :organization, presence: true

  validates :mobile, phony_plausible: true, presence: true, uniqueness: true

  validates :date_of_birth, presence: true
  validates :sex, inclusion: {in: lambda {|m| m.sex_enum}}

  validates :contact_preference, inclusion: {in: lambda {|m| m.contact_preference_enum}}
  validates :contact_availability, presence: true, if: lambda {%w(phone mobile).include?(self.contact_preference)}

  phony_normalize :phone, default_country_code: 'CH'
  phony_normalize :mobile, default_country_code: 'CH'

  validate :ensure_seeker_age_create, on: :create
  validate :ensure_seeker_age_update, on: :update

  validate :unique_email
  validates :email, uniqueness: true, allow_blank: true
  validate :unique_mobile

  before_validation :update_login, on: :update
  before_validation :set_login, on: :create

  after_destroy :delete_access_tokens

  after_save :adjust_todo
  after_create :create_rc_account_and_save
  after_create :send_welcome_message

  before_save :send_activation_message, if: proc {|s| s.status_changed? && s.active?}

  after_save :add_new_note

  before_save :generate_agreement_id
  before_update :create_rc_account

  before_create :set_rc_email

  after_create :send_create_to_jugendinfo
  after_update :send_update_to_jugendinfo, unless: -> { is_register }
  after_destroy :send_delete_to_jugendinfo


  # Adds new note to the database if it's present
  #
  def add_new_note
    return unless new_note.present?

    Note.create!(seeker_id: id, broker_id: current_broker_id, message: new_note)
  end

  # Creates new todos based on todotypes after saving seeker
  #
  def adjust_todo
    logger.info "Removing existing todos"
    Todo.where(record_type: :seeker, record_id: id).find_each &:destroy!
    logger.info "Creating new todos"
    Todotype.seeker.find_each do |todotype|
      begin
        result = Seeker.find_by(todotype.where + " AND id = #{id}")
        logger.info "Result: #{result}"
        unless result.nil?
          todo = Todo.create(record_id: id, record_type: :seeker, todotype: todotype, seeker_id: id)
          logger.info "Todo: #{todo}"
        end
      rescue
        logger.info "Error creating todo: #{$!}"
      end
    end
  end

  # Check if there is no provider or broker with the same email
  #
  def unique_email
    return if email.blank? || email.nil?

    provider = Provider.find_by(email: email)
    broker = Broker.find_by(email: email)
    if !provider.nil? || !broker.nil?
      errors.add(:email, :email_not_unique)
    end
  end


  def unique_mobile
    return if mobile.blank?
    broker = Broker.find_by(mobile: mobile)
    provider = Provider.find_by(mobile: mobile)
    if !broker.nil? || !provider.nil?
      errors.add(:mobile, :mobile_not_unique)
    end
  end

  # validate :ensure_work_category

  # validates_acceptance_of :terms, allow_nil: false, on: :create

  # after_save :send_agreement_email,    if: proc { |s| s.confirmed_at_changed? && s.confirmed_at_was.nil? }
  # after_save :send_registration_email, if: proc { |s| s.confirmed_at_changed? && s.confirmed_at_was.nil? }

  # Returns the display name
  #
  # @return [String] the name
  #
  def name
    "#{ firstname } #{ lastname }"
  end

  # Available options for the sex
  #
  # @return [Array<String>] the possible seeker sex
  #
  def sex_enum
    %w(male female other)
  end

  # Available options for the contact preference
  #
  # @return [Array<String>] the possible seeker contact preferences
  #
  def contact_preference_enum
    %w(email phone mobile postal whatsapp)
  end

  # @!group Devise

  # Check if the user can log in
  #
  # @return [Boolean] the status
  #
  def active_for_authentication?
    super && active?
  end

  # Return the I18n message key when authentication fails
  #
  # @return [Symbol] the i18n key
  #
  def unauthenticated_message
    # confirmed? ? :inactive : :unconfirmed
    :inactive
  end
  # @!endgroup
  #
  # Update seeker region through organization and set to inactive if region is changes
  #
  def update_organization(organization_id)
    if self.region != Organization.find(organization_id).regions.first
      self.organization_id = organization_id
      self.status = :inactive
    else
      self.organization_id = organization_id
    end
    self.save
  end

  # Return seeker current region
  # unused
  #
  def region_through_org
    return self.organization.regions.first if self.organization.present?
    nil
  end

  # Date of birth in '%d.%m.%Y' format
  #
  # @return [String] date or empty string
  #
  def date_of_birth_format
    return self.date_of_birth.strftime('%d.%m.%Y') if self.date_of_birth.present?
    ""
  end


  def create_rc_account
    if ENV['ROCKET_CHAT_URL'].present?
      rc = RocketChat::Users.new
      if self.rc_id.blank?
        user_rc_details = rc.find_user_by_email(self.rc_email)
      else
        user_rc_details = nil
      end
      if self.rc_id.blank? and user_rc_details.blank?
        env = ""
        env = "dev" if Rails.env == "development"

        user = rc.create({
                           name: self.name,
                           email: self.rc_email,
                           username: "smalljobs_s_#{env}#{self.id}",
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
    puts 'create_rc_account_and_save'
    self.create_rc_account
    puts 'create_rc_account_and_save 2'
    self.save
  end

  private

  def delete_access_tokens
    access_tokens.destroy_all
  end
  # Validate the job seeker age
  #
  # @return [Boolean] validation status
  #
  def ensure_seeker_age_create
    if date_of_birth.present? && !date_of_birth.between?(26.years.ago, 13.years.ago)
      errors.add(:date_of_birth, :invalid_seeker_age)
    end
  end

  # Validate the job seeker age
  #
  # @return [Boolean] validation status
  #
  def ensure_seeker_age_update
    if date_of_birth.present? && !(date_of_birth < 13.years.ago)
      errors.add(:date_of_birth, :invalid_seeker_age_update)
    end
  end

  # Ensure a seeker has at least one work category selected
  #
  # @return [Boolean] validation status
  #
  def ensure_work_category
    if work_categories.empty?
      errors.add(:work_categories, :invalid_work_category)
    end
  end

  # Send the seeker a welcome email
  # with the agreement pdf to sign and return.
  #
  def send_agreement_email
    Notifier.send_agreement_for_seeker(self).deliver
  end

  # Send the broker an email about the new seeker.
  #
  def send_registration_email
    Notifier.new_seeker_signup_for_broker(self).deliver
  end

  # Sends welcome message through chat to new seeker
  #
  def send_welcome_message
    title = 'Willkommen'
    host = "#{self.organization.regions.first.subdomain}.smalljobs.ch"
    seeker_agreement_link = "#{(Rails.application.routes.url_helpers.root_url(subdomain: self.organization.regions.first.subdomain, host: host, protocol: 'https'))}/broker/seekers/#{self.agreement_id}/agreement"
    message = Mustache.render(self.organization.welcome_chat_register_msg || '', organization_name: self.organization.name, organization_street: self.organization.street, organization_zip: self.organization.place.zip, organization_place: self.organization.place.name, organization_phone: self.organization.phone, organization_email: self.organization.email, seeker_first_name: self.firstname, seeker_last_name: self.lastname, broker_first_name: self.organization.brokers.first.try(:firstname).to_s, broker_last_name: self.organization.brokers.first.try(:lastname).to_s, seeker_link_to_agreement: "<a file type='application/pdf' title='Elterneinverständnis herunterladen' href='#{seeker_agreement_link}'>#{seeker_agreement_link}</a>", link_to_jobboard_list: (Rails.application.routes.url_helpers.root_url(subdomain: self.organization.regions.first.subdomain, host: host)))
    logger.info "Welcome message: #{message}"

    MessagingHelper::send_message(self.rc_id, self.rc_username, "#{title}. #{message}")
  end

  # Sends activation message through chat after seeker is activated
  #
  def send_activation_message
    title = 'Willkommen'
    host = "#{self.organization.regions.first.subdomain}.smalljobs.ch"

    seeker_agreement_link = "#{(Rails.application.routes.url_helpers.root_url(subdomain: self.organization.regions.first.subdomain, host: host, protocol: 'https'))}/broker/seekers/#{self.agreement_id}/agreement"
    message = Mustache.render(self.organization.activation_msg || '', organization_name: self.organization.name, organization_street: self.organization.street, organization_zip: self.organization.place.zip, organization_place: self.organization.place.name, organization_phone: self.organization.phone, organization_email: self.organization.email, seeker_first_name: self.firstname, seeker_last_name: self.lastname, broker_first_name: self.organization.brokers.first.try(:firstname).to_s, broker_last_name: self.organization.brokers.first.try(:lastname).to_s, seeker_link_to_agreement: "<a file type='application/pdf' title='Elterneinverständnis herunterladen' href='#{seeker_agreement_link}'>#{seeker_agreement_link}</a>", link_to_jobboard_list: (Rails.application.routes.url_helpers.root_url(subdomain: self.organization.regions.first.subdomain, host: host)))

    MessagingHelper::send_message(self.rc_id, self.rc_username, "#{title}. #{message}")
  end

  public

  # show seeker age
  def age
    return Date.today.year - self.date_of_birth.year if self.date_of_birth.present?
    return 0
  end


  def stat_name
    if completed?
      return "finished"
    end

    return "active"
  end

  def generate_agreement_id
    self.agreement_id = SecureRandom.uuid if self.agreement_id.nil?
  end

  # Return phone if exist, if not return mobile
  #
  # @return [String] phone or mobile
  #
  def phone_or_mobile
    return phone if phone.present?
    return mobile
  end

  def update_login
    if self.mobile != self.mobile_was
      self.login = self.mobile
    end
  end

  def set_login
    self.login = self.mobile
  end


  def set_rc_email
    if self.email.present?
      self.rc_email = self.email
    else
      self.rc_email = "#{SecureRandom.uuid}@smalljobs.ch"
    end
  end
end
