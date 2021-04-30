class Note < ActiveRecord::Base
  belongs_to :job
  belongs_to :broker
  belongs_to :provider
  belongs_to :seeker

  validates :message, presence: true
end
