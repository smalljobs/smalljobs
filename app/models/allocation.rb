class Allocation < ActiveRecord::Base
  belongs_to :job
  belongs_to :seeker

  validates :job, presence: true
  validates :seeker, presence: true
end
