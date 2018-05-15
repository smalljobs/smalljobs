class Seeker < ActiveRecord::Base

  devise :database_authenticatable, :registerable, authentication_keys: [:login]

  # include ConfirmToggle

  enum status: {inactive: 1, active: 2, completed: 3}

  has_and_belongs_to_many :work_categories
  has_and_belongs_to_many :certificates

  has_many :allocations, dependent: :destroy
  has_many :assignments, dependent: :destroy
  has_many :access_tokens, dependent: :destroy
  # has_many :notes

  has_many :jobs, through: :allocations

  has_many :todos

  belongs_to :place, inverse_of: :seekers
  belongs_to :organization

  attr_accessor :new_note
  attr_accessor :current_broker_id

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

  validate :ensure_seeker_age

  validate :unique_email

  after_save :send_to_jugendinfo

  after_save :adjust_todo

  after_create :send_welcome_message

  before_save :send_activation_message, if: proc { |s| s.status_changed? && s.active?}

  after_save :add_new_note

  def add_new_note
    return unless new_note.present?

    Note.create!(seeker_id: id, broker_id: current_broker_id, message: new_note)
  end

  def adjust_todo
    Todo.where(record_type: :seeker, record_id: id).find_each &:destroy!
    Todotype.seeker.find_each do |todotype|
      begin
        result = Seeker.find_by(todotype.where + " AND id = #{id}")
        unless result.nil?
          Todo.create(record_id: id, record_type: :seeker, todotype: todotype, seeker_id: id)
        end
      rescue
        nil
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

  private

  # Validate the job seeker age
  #
  # @return [Boolean] validation status
  #
  def ensure_seeker_age
    if date_of_birth.present? && !date_of_birth.between?(26.years.ago, 13.years.ago)
      errors.add(:date_of_birth, :invalid_seeker_age)
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

  # Make post request to jugendinfo API
  #
  def send_to_jugendinfo
    require 'rest-client'
    dev = 'https://devadmin.jugendarbeit.digital/api/jugendinfo_user/update_data/'
    live = 'https://admin.jugendarbeit.digital/api/jugendinfo_user/update_data/'
    begin
      logger.info "Sending changes to jugendinfo"
      logger.info "Sending: #{{token: '1bN1SO2W1Ilz4xL2ld364qVibI0PsfEYcKZRH', id: app_user_id, smalljobs_user_id: id, firstname: firstname, lastname: lastname, mobile: mobile, address: street, zip: place.zip, birthdate: date_of_birth.strftime('%Y-%m-%d'), city: place.name, smalljobs_status: Seeker.statuses[status]}}"
      response = RestClient.post dev, {token: '1bN1SO2W1Ilz4xL2ld364qVibI0PsfEYcKZRH', id: app_user_id, smalljobs_user_id: id, firstname: firstname, lastname: lastname, mobile: mobile, address: street, zip: place.zip, birthdate: date_of_birth.strftime('%Y-%m-%d'), city: place.name, smalljobs_status: Seeker.statuses[status]}
      logger.info "Response from jugendinfo: #{response}"
    rescue
      logger.info "Failed sending changes to jugendinfo"
      nil
    end
  end

  # Sends welcome message through chat to new seeker
  #
  def send_welcome_message
    title = 'Willkommen'
    host = "#{self.organization.regions.first.subdomain}.smalljobs.ch"
    message = Mustache.render(self.organization.welcome_chat_register_msg, organization_name: self.organization.name, organization_street: self.organization.street, organization_zip: self.organization.places.first.zip, organization_place: self.organization.places.first.name, organization_phone: self.organization.phone, organization_email: self.organization.email, seeker_first_name: self.firstname, seeker_last_name: self.lastname, broker_first_name: self.organization.brokers.first.firstname, broker_last_name: self.organization.brokers.first.lastname, seeker_link_to_agreement: (Rails.application.routes.url_helpers.agreement_broker_seeker_url(self, subdomain: 'winterthur', host: host)), link_to_jobboard_list: (Rails.application.routes.url_helpers.root_url(subdomain: self.organization.regions.first.subdomain, host: host)))

    MessagingHelper::send_message(title, message, self.app_user_id, self.organization.email)
  end

  # Sends activation message through chat after seeker is activated
  #
  def send_activation_message
    title = 'Willkommen'
    host = "#{self.organization.regions.first.subdomain}.smalljobs.ch"
    message = Mustache.render(self.organization.activation_msg, organization_name: self.organization.name, organization_street: self.organization.street, organization_zip: self.organization.places.first.zip, organization_place: self.organization.places.first.name, organization_phone: self.organization.phone, organization_email: self.organization.email, seeker_first_name: self.firstname, seeker_last_name: self.lastname, broker_first_name: self.organization.brokers.first.firstname, broker_last_name: self.organization.brokers.first.lastname, seeker_link_to_agreement: (Rails.application.routes.url_helpers.agreement_broker_seeker_url(self, subdomain: 'winterthur', host: host)), link_to_jobboard_list: (Rails.application.routes.url_helpers.root_url(subdomain: self.organization.regions.first.subdomain, host: host)))

    MessagingHelper::send_message(title, message, self.app_user_id, self.organization.email)
  end

  public

  def stat_name
    if completed?
      return "finished"
    end

    return "active"
  end
end
