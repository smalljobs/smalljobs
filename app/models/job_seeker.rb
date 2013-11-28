class JobSeeker < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :employments
  has_many :organizations, through: :employments

  validates :firstname, :lastname, presence: true

  validates :street, :zip, :city, presence: true
  validates :zip, postal_code: { country: :ch }

  validates :email, email: true, allow_blank: true
  validates :phone, :mobile, phony_plausible: true

  validates :contact_preference, inclusion: { in: lambda { |m| m.contact_preference_enum } }
  validates :contact_availability, presence: true, if: lambda { %w(phone mobile).include?(self.contact_preference) }

  phony_normalize :phone,  default_country_code: 'CH'
  phony_normalize :mobile, default_country_code: 'CH'

  def active_for_authentication?
    super && active?
  end

  def contact_preference_enum
    %w(email phone mobile postal whatsapp)
  end
end
