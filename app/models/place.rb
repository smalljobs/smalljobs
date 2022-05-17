class Place < ActiveRecord::Base
  belongs_to :region, inverse_of: :places

  has_many :providers
  has_many :jobs, through: :providers
  has_many :seekers
  has_one :organization
  belongs_to :country

  validates :zip, :name, :longitude, :latitude, presence: true

  def custom_name
    "#{zip} #{name}"
  end

  def full_name
    "#{zip} #{name}"
  end
end
