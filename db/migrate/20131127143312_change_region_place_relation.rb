class ChangeRegionPlaceRelation < ActiveRecord::Migration
  def change
    drop_table :places_regions
    add_reference :places, :region, index: true
  end
end
