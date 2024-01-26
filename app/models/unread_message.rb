class UnreadMessage < ApplicationRecord
  belongs_to :broker
  belongs_to :seeker
end
