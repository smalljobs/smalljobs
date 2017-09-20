class AddSettingsToBroker < ActiveRecord::Migration
  def change
    add_column :brokers, :settings, :jsonb, null: false, default: {}
  end
end
