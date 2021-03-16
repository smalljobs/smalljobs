class Provider < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, authentication_keys: [:email]

  enum state: {inactive: 1, active: 2, completed: 3}

  has_many :jobs
  has_many :assignments
  has_many :allocation
  belongs_to :place, inverse_of: :providers
  belongs_to :organization
  # has_many :notes

  has_many :todos, dependent: :destroy

  attr_accessor :new_note
  attr_accessor :current_broker_id

  before_save :nullify_blank_email

  validates :firstname, :lastname, presence: true

  validates :organization, presence: true

  validates :street, :place, presence: true

  validates :email, email: true, unless: 'email.nil? || email.blank?'
  validates :email, uniqueness: true, unless: 'email.nil? || email.blank?'
  validates :phone, phony_plausible: true
  validates :mobile, phony_plausible: true

  validates :contact_preference, inclusion: {in: lambda {|m| m.contact_preference_enum}}

  validates_acceptance_of :terms, allow_nil: false, on: :create

  phony_normalize :phone, default_country_code: 'CH'
  phony_normalize :mobile, default_country_code: 'CH'

  after_save :send_registration_email, if: proc {|s| s.confirmed_at_changed? && s.confirmed_at_was.nil?}
  after_save :send_activation_email, if: proc {|s| s.active_changed? && s.active_was == false}

  after_save :adjust_todo

  validate :unique_email
  validate :unique_mobile, on: :create

  after_save :add_new_note

  before_save :set_default_state

  # Sets default state after initializing model
  #
  def set_default_state
    state ||= :inactive
  end

  # Add new note to the model
  #
  def add_new_note
    return unless new_note.present?

    Note.create!(provider_id: id, broker_id: current_broker_id, message: new_note)
  end

  # Destroy old todos and create new ones
  #
  def adjust_todo
    Todo.where(record_type: :provider, record_id: id).find_each &:destroy!
    Todotype.provider.find_each do |todotype|
      begin
        result = Provider.find_by(todotype.where + " AND id = #{id}")
        unless result.nil?
          Todo.create(record_id: id, record_type: :provider, todotype: todotype, provider_id: id)
        end
      rescue
        nil
      end
    end
  end

  # Check if there is no seeker or broker with the same email
  #
  def unique_email
    return if email.blank? || email.nil?

    seeker = Seeker.find_by(email: email)
    broker = Broker.find_by(email: email)
    if !seeker.nil? || !broker.nil?
      errors.add(:email, :email_not_unique)
    end
  end


  def unique_mobile
    seeker = Seeker.find_by(mobile: mobile)
    broker = Broker.find_by(mobile: mobile)
    if !seeker.nil? || !broker.nil?
      errors.add(:mobile, :mobile_not_unique)
    end
  end

  # Returns the display name
  #
  # @return [String] the name
  #
  def name
    "#{firstname} #{lastname}"
  end

  # Available options for the contact preference
  #
  # @return [Array<String>] the contact options
  #
  def contact_preference_enum
    %w(email phone mobile postal)
  end

  # @!group Devise

  # Is the Email needed for login
  #
  # @return [Boolean] validation status
  #
  def email_required?
    false
  end

  # Check if the user can log in
  #
  # @return [Boolean] the status
  #
  def active_for_authentication?
    super
  end

  # Return the I18n message key when authentication fails
  #
  # @return [Symbol] the i18n key
  #
  def unauthenticated_message
    # confirmed? ? :inactive : :unconfirmed
    :inactive
  end

  # Return the I18n message key when account is inactive
  #
  # @return [Symbol] the i18n key
  #
  def inactive_message
    super
  end

  # Return phone if exist, if not return mobile
  #
  # @return [String] phone or mobile
  #
  def phone_or_mobile
    return phone if phone.present?
    return mobile
  end

  # @!endgroup

  protected

  # Ensure email is nil when blank, so we
  # do not trigger the unique constraint
  #
  def nullify_blank_email
    email = nil if email.blank?
  end

  # Send the broker an email about the new seeker.
  #
  def send_registration_email
    Notifier.new_provider_signup_for_broker(self).deliver
  end

  # Send the provider an email about his activation.
  #
  def send_activation_email
    Notifier.provider_activated_for_provider(self).deliver
  end

  public

  # Used for search in the dashboard
  #
  def stat_name
    if completed?
      return "finished"
    end

    return "active"
  end
end
