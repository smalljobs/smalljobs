Fabricator(:broker) do
  transient confirmed: true

  firstname { Forgery(:name).first_name }
  lastname  { Forgery(:name).last_name }

  email     { Forgery(:internet).email_address }
  password  { Forgery(:basic).password.rjust(10, 'a') }

  phone     { '044 444 44 44' }
  mobile    { '079 444 44 44' }

  active    { true }

  after_create do |user, transients|
    user.confirm! if transients[:confirmed]
  end
end

Fabricator(:broker_with_regions, from: :broker) do
  after_create do |user, transients|
      place_1        = Fabricate(:place, zip: '1234', name: 'Vessy')
      region_1       = Fabricate(:region, places: [place_1])
      organization_1 = Fabricate(:organization)

      Fabricate(:employment,
                organization: organization_1,
                region: region_1,
                broker: user)

      place_2        = Fabricate(:place, zip: '1235', name: 'Ausserwil')
      place_3        = Fabricate(:place, zip: '1236', name: 'Cartigny')
      region_2       = Fabricate(:region, places: [place_2, place_3])
      organization_2 = Fabricate(:organization)

      Fabricate(:employment,
                organization: organization_2,
                region: region_2,
                broker: user)
  end
end
