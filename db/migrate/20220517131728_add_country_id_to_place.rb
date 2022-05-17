class AddCountryIdToPlace < ActiveRecord::Migration[5.0]
  def change
    add_column :places, :country_id, :integer
  end
end
