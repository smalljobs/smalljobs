class Assignment < ActiveRecord::Base
  belongs_to :seeker
  belongs_to :provider
  enum status: [:active, :finished]
end
