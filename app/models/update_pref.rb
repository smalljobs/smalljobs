class UpdatePref < ActiveRecord::Base
  has_and_belongs_to_many :brokers

  validates :name, presence: true
  validates :day_of_week, presence: true
end