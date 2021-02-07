class AddJiLocationToRegion < ActiveRecord::Migration[5.0]
  def change
    add_column :regions, :ji_location_id, :integer
    add_column :regions, :ji_location_name, :string
  end
end
