Fabricator(:seeker) do
  transient broker: true

  firstname { Forgery(:name).first_name }
  lastname  { Forgery(:name).last_name }

  street { "#{ Forgery(:address).street_name } #{ Forgery(:address).street_number }" }
  place

  date_of_birth { 15.years.ago }
  sex { ['male', 'female', 'other'].sample }

  password { Forgery(:basic).password.rjust(10, 'a') }
  email    { sequence(:email)  { |i| "seeker#{ i }@example.com" }}
  phone    { sequence(:phone)  { |i| "+41 056 111 22 3#{ rand(9) }" }}
  mobile   { sequence(:mobile) { |i| "+41 079 111 22 3#{ rand(9) }" }}
  login    { sequence(:login)  { |i| "+41 079 111 22 3#{ rand(9) }" }}

  contact_preference  { 'mobile' }
  contact_availability { 'all day' }

  work_categories(count: 1)

  active { true }

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
