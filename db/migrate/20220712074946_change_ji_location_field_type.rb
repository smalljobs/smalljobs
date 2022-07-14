class ChangeJiLocationFieldType < ActiveRecord::Migration[5.0]
  def up
    change_column :regions, :ji_location_id, :string
  end

  def down
    change_column :regions, :ji_location_id, :integer
  end
end
