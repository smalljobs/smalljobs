class Place < ActiveRecord::Base
  belongs_to :region

  validates :zip, :name, :longitude, :latitude, presence: true
end
