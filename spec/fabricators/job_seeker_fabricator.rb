Fabricator(:job_seeker) do
  firstname { Forgery(:name).first_name }
  lastname  { Forgery(:name).last_name }

  street { "#{ Forgery(:address).street_name } #{ Forgery(:address).street_number }" }
  zip    { Random.rand(9999).to_s.rjust(4, '0') }
  city   { Forgery(:address).city }

  date_of_birth { 15.years.ago }

  email     { Forgery(:internet).email_address }
  password  { Forgery(:basic).password.rjust(10, 'a') }

  contact_preference  { 'mobile' }
  contact_availability { 'all day' }

  work_categories(count: 1)
end
