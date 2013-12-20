class Broker < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :registerable

  has_many :employments, inverse_of: :broker
  has_many :organizations, through: :employments
  has_many :regions, through: :employments
  has_many :places, through: :regions

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

  # Get the provider this broker is responsible for
  #
  # @return [ActiveRecord::Relation<Provider>] the providers
  #
  def providers
    Provider.where(zip: places.pluck(:zip))
  end

  # Get the seekers this broker is responsible for
  #
  # @return [ActiveRecord::Relation<Seeker>] the seekers
  #
  def seekers
    Seeker.where(zip: places.pluck(:zip))
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
