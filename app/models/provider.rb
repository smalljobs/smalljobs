class Provider < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, authentication_keys: [:username]

  include ConfirmToggle

  has_many :jobs
  belongs_to :place, inverse_of: :providers

  before_save :nullify_blank_email

  validates :username, presence: true, uniqueness: true
  validates :firstname, :lastname, presence: true

  validates :street, :place, presence: true

  validates :email, email: true, allow_blank: true, allow_nil: true
  validates :phone, :mobile, phony_plausible: true

  validates :contact_preference, inclusion: { in: lambda { |m| m.contact_preference_enum } }
  validates :contact_availability, presence: true, if: lambda { %w(phone mobile).include?(self.contact_preference) }

  phony_normalize :phone,  default_country_code: 'CH'
  phony_normalize :mobile, default_country_code: 'CH'

  after_save :send_registration_email, if: proc { |s| s.confirmed_at_changed? && s.confirmed_at_was.nil? }
  after_save :send_activation_email,   if: proc { |s| s.active_changed? && s.active_was == false }

  # Returns the display name
  #
  # @return [String] the name
  #
  def name
    "#{ firstname } #{ lastname }"
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
    super && active?
  end

  # Return the I18n message key when authentication fails
  #
  # @return [Symbol] the i18n key
  #
  def unauthenticated_message
    confirmed? ? :inactive : :unconfirmed
  end

  # Return the I18n message key when account is inactive
  #
  # @return [Symbol] the i18n key
  #
  def inactive_message
    if !confirmed?
      self.email.blank? ? :unconfirmed_manual : :unconfirmed
    else
      super
    end
  end

  # @!endgroup

  protected

  # Ensure email is nil when blank, so we
  # do not trigger the unique constraint
  #
  def nullify_blank_email
    self.email = nil if self.email.blank?
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

end
