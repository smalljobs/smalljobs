class MigrateOrganizationToPlace < ActiveRecord::Migration
  def change
    add_reference :organizations, :place

    Organization.find_each do |organization|
      place = Place.find_by_zip(organization.zip)
      organization.update_attribute(:place_id, place.id) if place
    end

    remove_column :organizations, :zip
    remove_column :organizations, :city
  end
end
