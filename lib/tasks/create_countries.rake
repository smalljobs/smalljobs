namespace :countries do
  task create: :environment do
    countries = [
      ["Germany", "DE"],
      ["Switzerland", "CH"]
    ]

    countries.each do |name, alpha2|
      next if Country.where(name: name, alpha2: alpha2).exists?

      Country.create(name: name, alpha2: alpha2)
    end

    country = Country.find_by_name('Switzerland')
    Region.update_all(country_id: country.id)
  end
end
