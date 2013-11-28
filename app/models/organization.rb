class Organization < ActiveRecord::Base
  has_many :employments
  has_many :job_brokers, through: :employments

  validates :name, presence: true, uniqueness: true
  validates :website, url: true

  validates :street, :zip, :city, presence: true
  validates :zip, postal_code: { country: :ch }

  validates :email, email: true, presence: true
  validates :phone, phony_plausible: true, presence: true

  phony_normalize :phone,  default_country_code: 'CH'

  mount_uploader :logo, LogoUploader
  mount_uploader :background, BackgroundUploader
end
