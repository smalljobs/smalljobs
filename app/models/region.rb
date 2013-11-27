class Region < ActiveRecord::Base
  has_and_belongs_to_many :places

  validates :name, presence: true
  validates :places, length: { minimum: 1 }
end
