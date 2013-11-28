class Place < ActiveRecord::Base
  belongs_to :region, inverse_of: :places

  validates :zip, :name, :longitude, :latitude, presence: true
end
