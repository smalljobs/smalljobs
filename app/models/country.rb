class Country < ActiveRecord::Base
  has_many :regions
  has_many :places

  validates :name, presence: true
end
