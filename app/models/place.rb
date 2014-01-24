class Place < ActiveRecord::Base
  belongs_to :region, inverse_of: :places

  has_many :providers
  has_many :seekers

  validates :zip, :name, :longitude, :latitude, presence: true
end
