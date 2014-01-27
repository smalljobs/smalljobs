class Organization < ActiveRecord::Base
  has_many :employments, inverse_of: :organization
  has_many :brokers, through: :employments
  has_many :regions, through: :employments
  has_many :places, through: :regions

  belongs_to :place, inverse_of: :organization

  validates :name, presence: true, uniqueness: true
  validates :website, url: true, allow_blank: true, allow_nil: true

  validates :street, :place, presence: true

  validates :email, email: true, presence: true
  validates :phone, phony_plausible: true, allow_blank: true, allow_nil: true

  phony_normalize :phone,  default_country_code: 'CH'

  mount_uploader :logo, LogoUploader
  mount_uploader :background, BackgroundUploader
end
