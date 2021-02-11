class AddAppUserIdToBroker < ActiveRecord::Migration[5.0]
  def change
    add_column :brokers, :app_user_id, :integer
  end
end
