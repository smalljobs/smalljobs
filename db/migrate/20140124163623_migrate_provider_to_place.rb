class MigrateProviderToPlace < ActiveRecord::Migration
  def change
    add_reference :providers, :place

    Provider.find_each do |provider|
      place = Place.find_by_zip(provider.zip)
      provider.update_attribute(:place_id, place.id) if place
    end

    remove_column :providers, :zip
    remove_column :providers, :city
  end
end
