namespace :smalljobs do

  desc 'Delete unused orte'
  task delete_unused_orte: :environment do
    Region.all.each do |region|
      Place.all.each do |place|
        if region.places.find_by(id: place.id).nil?
          place.destroy
        end
      end
    end
  end

end
