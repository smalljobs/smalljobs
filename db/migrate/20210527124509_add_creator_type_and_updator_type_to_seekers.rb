class AddCreatorTypeAndUpdatorTypeToSeekers < ActiveRecord::Migration[5.0]
  def change
    add_column :seekers, :creator_type, :user_role, index: true
    add_column :seekers, :updater_type, :user_role, index: true
  end
end
