class BroadcastMessage < ApplicationRecord
  has_many :broadcast_message_seekers
  has_many :seekers, through: :broadcast_message_seekers
  belongs_to :broker



end
