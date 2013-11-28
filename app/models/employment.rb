class Employment < ActiveRecord::Base
  belongs_to :organization
  belongs_to :job_broker
  belongs_to :region

  validates :organization, :job_broker, :region, presence: true
end
