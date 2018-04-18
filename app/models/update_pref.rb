class UpdatePref < ActiveRecord::Base
  validates :name, presence: true
  validates :day_of_week, presence: true
end