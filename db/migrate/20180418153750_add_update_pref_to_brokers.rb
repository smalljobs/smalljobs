class AddUpdatePrefToBrokers < ActiveRecord::Migration[5.0]
  def change
    add_column :brokers, :update_pref, :integer, default: 3
  end
end
