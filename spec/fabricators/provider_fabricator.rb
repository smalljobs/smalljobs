Fabricator(:provider) do
  transient confirmed: true

  username  { sequence(:username) { |i| "user#{ i }" }}
  password  { Forgery(:basic).password.rjust(10, 'a') }

  firstname { Forgery(:name).first_name }
  lastname  { Forgery(:name).last_name }

  street { "#{ Forgery(:address).street_name } #{ Forgery(:address).street_number }" }
  zip    { Random.rand(9999).to_s.rjust(4, '0') }
  city   { Forgery(:address).city }

  contact_preference  { 'mobile' }
  contact_availability { 'all day' }

  active { true }

  after_create do |user, transients|
    user.confirm! if transients[:confirmed]
  end
end
