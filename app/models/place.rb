class Place < ActiveRecord::Base
  has_and_belongs_to_many :regions

  validates :zip, :name, :longitude, :latitude, presence: true
end
