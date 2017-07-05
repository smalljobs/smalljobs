class Broker < ActiveRecord::Base

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :registerable, authentication_keys: [:email]

  include ConfirmToggle
  include Storext.model

  has_many :employments, inverse_of: :broker
  has_many :organizations, through: :employments
  has_many :regions, through: :employments
  has_many :places, through: :regions
  has_many :providers, through: :places
  has_many :seekers, through: :places
  has_many :jobs, through: :providers
  has_many :assignments, through: :providers

  validates :email, email: true, presence: true, uniqueness: true
  validates :firstname, :lastname, :phone, presence: true
  validates :phone, :mobile, phony_plausible: true

  phony_normalize :phone, default_country_code: 'CH'
  phony_normalize :mobile, default_country_code: 'CH'

  store_attributes :settings do
    selected_organization_id Integer, default: 0
    filter String, default: ''
  end

  def all_organizations
    all_org = []
    regions.each do |region|
      region.organizations.each do |organization|
        all_org.append(organization) if all_org.find_index(organization).nil?
      end
    end

    all_org.sort_by &:name
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

  # @!endgroup
end
