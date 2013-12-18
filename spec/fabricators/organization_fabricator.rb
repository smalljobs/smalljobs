Fabricator(:organization) do
  name { Forgery(:name).company_name }
  website { "http://#{ Forgery(:internet).domain_name }" }
  street { "#{ Forgery(:address).street_name } #{ Forgery(:address).street_number }" }
  zip    { Random.rand(9999).to_s.rjust(4, '0') }
  city   { Forgery(:address).city }
  email  { Forgery(:internet).email_address }
  phone  { '044 444 44 44' }
end
