require 'csv'

CSV.foreach(File.expand_path(File.join('db', 'data', 'postal_codes', 'CH.csv')), col_sep: "\t") do |row|
  Place.where(
    zip:       row[1],
    name:      row[2],
    state:     row[4],
    province:  row[5],
    longitude: row[9],
    latitude:  row[10]
  ).first_or_create
end

Place.all.find_each do |place|
  place.region_id = 1
  place.save!
end

Region.all.find_each do |region|
  region.destroy
end
Region.create!(subdomain: 'smalljobs', name: 'smalljobs', id: 1)