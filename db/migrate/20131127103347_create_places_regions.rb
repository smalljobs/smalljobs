class CreatePlacesRegions < ActiveRecord::Migration
  def change
    create_table :places_regions do |t|
      t.references :place
      t.references :region
    end
  end
end
