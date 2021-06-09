class AddCreatorTypeAndUpdaterTypeToBrokers < ActiveRecord::Migration[5.0]
  def change
    add_column :brokers, :creator_type, :user_role, index: true
    add_column :brokers, :updater_type, :user_role, index: true
  end
end
