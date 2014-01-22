Fabricator(:seeker) do
  transient confirmed: true

  firstname { Forgery(:name).first_name }
  lastname  { Forgery(:name).last_name }

  street { "#{ Forgery(:address).street_name } #{ Forgery(:address).street_number }" }
  zip    { Random.rand(9999).to_s.rjust(4, '0') }
  city   { Forgery(:address).city }

  date_of_birth { 15.years.ago }

  password { Forgery(:basic).password.rjust(10, 'a') }
  email    { sequence(:email)  { |i| "seeker#{ i }@example.com" }}
  phone    { sequence(:phone)  { |i| "0041 056 111 22 3#{ i }" }}
  mobile   { sequence(:mobile) { |i| "0041 079 111 22 3#{ i }" }}

  contact_preference  { 'mobile' }
  contact_availability { 'all day' }

  active { true }

  contact_preference  { 'mobile' }
  contact_availability { 'all day' }

  work_categories(count: 1)

  active { true }

  after_create do |user, transients|
    user.confirm! if transients[:confirmed]
  end
end
