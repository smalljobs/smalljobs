class CreateUnreadMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :unread_messages do |t|
      t.integer :broker_id
      t.integer :seeker_id
      t.integer :quantity

      t.timestamps
    end
  end
end
