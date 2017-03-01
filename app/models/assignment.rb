class Assignment < ActiveRecord::Base
  belongs_to :seeker
  belongs_to :provider
  belongs_to :job

  validates :provider, presence: true
  validates :seeker, presence: true

  enum status: [:active, :finished]
end
