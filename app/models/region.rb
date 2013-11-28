class Region < ActiveRecord::Base
  has_many :places

  validates :name, presence: true, uniqueness: true
  validates :places, length: { minimum: 1 }
end
