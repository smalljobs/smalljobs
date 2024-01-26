class BrokerUnreadMessageTimestamp < ActiveRecord::Migration[5.0]
  def change
    add_column :brokers, :unread_messages_timestamp, :datetime, default: nil
  end
end
