class CreateBroadcastMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :broadcast_messages do |t|
      t.integer :broker_id
      t.text :message

      t.timestamps
    end
  end
end
