class AddLoginToBrokers < ActiveRecord::Migration
  def change
    add_column :brokers, :login, :string, default: "", null: false
  end
end
