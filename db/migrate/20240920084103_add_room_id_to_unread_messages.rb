class AddRoomIdToUnreadMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :unread_messages, :room_id, :string
  end
end
