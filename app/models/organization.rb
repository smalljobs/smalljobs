class Organization < ActiveRecord::Base
  has_many :employments, inverse_of: :organization
  has_many :job_brokers, through: :employments
  has_many :regions, through: :employments

  validates :name, presence: true, uniqueness: true
  validates :website, url: true, allow_blank: true, allow_nil: true

  validates :street, :zip, :city, presence: true
  validates :zip, postal_code: { country: :ch }

  validates :email, email: true, presence: true
  validates :phone, phony_plausible: true, allow_blank: true, allow_nil: true

  phony_normalize :phone,  default_country_code: 'CH'

  mount_uploader :logo, LogoUploader
  mount_uploader :background, BackgroundUploader
end
