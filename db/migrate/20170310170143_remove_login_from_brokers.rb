class RemoveLoginFromBrokers < ActiveRecord::Migration
  def change
    remove_column :brokers, :login, :string
  end
end
