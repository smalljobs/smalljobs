class AddRcTokenToBroker < ActiveRecord::Migration[5.0]
  def change
    add_column :brokers, :rc_token, :string
  end
end
