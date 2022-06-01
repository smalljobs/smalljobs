class AddCountryRelationToRegion < ActiveRecord::Migration[5.0]
  def change
    add_column :regions, :country_id, :integer
  end
end
