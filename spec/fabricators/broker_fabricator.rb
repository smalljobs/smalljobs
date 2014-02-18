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
  transient :place

  after_create do |user, transients|
    if transients[:place]
      unless transients[:place].region
        Fabricate(:region, places: [transients[:place]])
      end

      Fabricate(:employment,
                organization: Fabricate(:organization),
                region: transients[:place].region,
                broker: user)
    else
      Fabricate(:employment,
                organization: Fabricate(:organization),
                region: Fabricate(:region, places: [
                  Fabricate(:place, zip: '1234', name: 'Vessy')
                ]),
                broker: user)

      Fabricate(:employment,
                organization: Fabricate(:organization),
                region: Fabricate(:region, places: [
                  Fabricate(:place, zip: '1235', name: 'Ausserwil'),
                  Fabricate(:place, zip: '1236', name: 'Cartigny')
                ]),
                broker: user)
    end
  end
end
