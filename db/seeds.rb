require 'csv'

CSV.foreach(File.expand_path(File.join('db', 'data', 'postal_codes', 'CH.csv')), col_sep: "\t") do |row|
  Place.where(
      zip: row[1],
      name: row[2],
      state: row[4],
      province: row[5],
      longitude: row[9],
      latitude: row[10]
  ).first_or_create
end

Place.all.find_each do |place|
  place.region_id = 0
  place.save!
end

place = Place.first
place.region_id = 1
place.save!

Region.all.find_each do |region|
  region.destroy
end
Region.create!(subdomain: 'smalljobs', name: 'smalljobs', id: 1)

Organization.where(
    name: 'smalljobs org',
    website: 'smalljobs.herokuapp.com',
    description: 'smalljobs organization',
    street: 'Street 1',
    email: 'email@mail.com',
    phone: '111111111',
    place_id: place.id
).first_or_create