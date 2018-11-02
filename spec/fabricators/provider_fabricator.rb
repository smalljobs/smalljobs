Fabricator(:provider) do
  transient broker: true

  # username  { sequence(:username) { |i| "user#{ i }" }}
  password  { Forgery(:basic).password.rjust(10, 'a') }

  firstname { Forgery(:name).first_name }
  lastname  { Forgery(:name).last_name }

  street { "#{ Forgery(:address).street_name } #{ Forgery(:address).street_number }" }
  place

  email  { sequence(:email)  { |i| "provider#{ i }@example.com" }}
  phone  { sequence(:phone)  { |i| "+41 056 111 22 3#{ rand(9) }" }}
  mobile { sequence(:mobile) { |i| "+41 079 111 22 3#{ rand(9) }" }}

  contact_preference  { 'mobile' }
  contact_availability { 'all day' }

  active { true }
  terms { '1' }

  organization

  after_build do |user, transients|
    if transients[:broker]
      Fabricate(:broker_with_regions, place: user.place)
    end
  end

  # after_create do |user, transients|
  #   user.confirm! if transients[:confirmed]
  # end
end
