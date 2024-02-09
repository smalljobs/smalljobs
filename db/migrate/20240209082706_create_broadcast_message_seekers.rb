class CreateBroadcastMessageSeekers < ActiveRecord::Migration[5.0]
  def change
    create_table :broadcast_message_seekers do |t|
      t.integer :seeker_id
      t.integer :broadcast_message_id

      t.timestamps
    end
  end
end
