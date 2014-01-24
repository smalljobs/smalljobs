class MigrateSeekerToPlace < ActiveRecord::Migration
  def change
    add_reference :seekers, :place

    Seeker.find_each do |seeker|
      place = Place.find_by_zip(seeker.zip)
      seeker.update_attribute(:place_id, place.id) if place
    end

    remove_column :seekers, :zip
    remove_column :seekers, :city
  end
end
