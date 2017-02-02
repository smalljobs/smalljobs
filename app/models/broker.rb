class Broker < ActiveRecord::Base

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :registerable, authentication_keys: [:login]

  include ConfirmToggle

  has_many :employments, inverse_of: :broker
  has_many :organizations, through: :employments
  has_many :regions, through: :employments
  has_many :places, through: :regions
  has_many :providers, through: :places
  has_many :seekers, through: :places
  has_many :jobs, through: :providers

  validates :login, presence: true, uniqueness: true
  validates :firstname, :lastname, :phone, presence: true
  validates :phone, :mobile, phony_plausible: true

  phony_normalize :phone,  default_country_code: 'CH'
  phony_normalize :mobile, default_country_code: 'CH'

  # Returns the display name
  #
  # @return [String] the name
  #
  def name
    "#{ firstname } #{ lastname }"
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
    confirmed? ? :inactive : :unconfirmed
  end

  # @!endgroup
end
