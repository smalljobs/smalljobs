class AddLastMessageTimestampToUnreadMessage < ActiveRecord::Migration[5.0]
  def change
    add_column :unread_messages, :last_message_timestamp, :datetime

    UnreadMessage.find_each do |um|
      um.update(last_message_timestamp: DateTime.now)
    end
  end
end
