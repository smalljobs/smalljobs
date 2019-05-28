class AddRoleToBrokers < ActiveRecord::Migration[5.0]
  def change
    add_column :brokers, :role, :text, default: :normal
  end
end
