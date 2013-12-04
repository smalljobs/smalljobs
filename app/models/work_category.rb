class WorkCategory < ActiveRecord::Base
  has_and_belongs_to_many :job_seekers

  validates :name, presence: true
end
