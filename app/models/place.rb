class Place < ActiveRecord::Base
  belongs_to :region, inverse_of: :places

  has_many :providers
  has_many :seekers
  has_one :organization

  validates :zip, :name, :longitude, :latitude, presence: true
end
