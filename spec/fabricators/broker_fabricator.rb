Fabricator(:broker) do
  transient confirmed: true

  firstname { Forgery(:name).first_name }
  lastname  { Forgery(:name).last_name }

  email     { Forgery(:internet).email_address }
  password  { Forgery(:basic).password.rjust(10, 'a') }

  phone     { "0041 044 444 44 4#{ rand(9) }" }
  mobile    { "0041 079 444 44 4#{ rand(9) }" }

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
                organization: Fabricate(:organization, place: transients[:place]),
                region: transients[:place].region,
                broker: user)
    else
      place_1 = Fabricate(:place, zip: '1234', name: 'Vessy')
      Fabricate(:employment,
                organization: Fabricate(:organization, place: place_1),
                region: Fabricate(:region, places: [place_1]),
                broker: user)

      place_2 = Fabricate(:place, zip: '1235', name: 'Ausserwil')
      Fabricate(:employment,
                organization: Fabricate(:organization, place: place_2),
                region: Fabricate(:region, places: [
                  place_2,
                  Fabricate(:place, zip: '1236', name: 'Cartigny')
                ]),
                broker: user)
    end
  end
end
