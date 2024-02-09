class BroadcastMessageSeeker < ApplicationRecord
  belongs_to :broadcast_messages
  belongs_to :seeker
end
