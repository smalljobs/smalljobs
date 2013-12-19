Fabricator(:job_broker) do
  transient confirmed: true

  firstname { Forgery(:name).first_name }
  lastname  { Forgery(:name).last_name }

  email     { Forgery(:internet).email_address }
  password  { Forgery(:basic).password.rjust(10, 'a') }

  phone     { '044 444 44 44' }

  active    { true }

  after_create do |user, transients|
    user.confirm! if transients[:confirmed]
  end
end

Fabricator(:job_broker_with_regions, from: :job_broker) do
  after_create do |user, transients|
      place_1        = Fabricate(:place, zip: '1234')
      region_1       = Fabricate(:region, places: [place_1])
      organization_1 = Fabricate(:organization)

      Fabricate(:employment,
                organization: organization_1,
                region: region_1,
                job_broker: user)

      place_2        = Fabricate(:place, zip: '1235')
      place_3        = Fabricate(:place, zip: '1236')
      region_2       = Fabricate(:region, places: [place_2, place_3])
      organization_2 = Fabricate(:organization)

      Fabricate(:employment,
                organization: organization_2,
                region: region_2,
                job_broker: user)
  end
end
