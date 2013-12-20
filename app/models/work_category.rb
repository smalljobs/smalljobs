class WorkCategory < ActiveRecord::Base
  has_and_belongs_to_many :seekers

  validates :name, presence: true
end
