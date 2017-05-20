class Todo < ApplicationRecord
  enum record_type: { job: 1, provider: 2, allocation: 3, seeker: 4 }

  belongs_to :todotype
  belongs_to :seeker
  belongs_to :provider
  belongs_to :job
  belongs_to :allocation
end
