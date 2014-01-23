class WorkCategory < ActiveRecord::Base
  has_and_belongs_to_many :seekers
  has_many :jobs

  validates :name, presence: true
end
