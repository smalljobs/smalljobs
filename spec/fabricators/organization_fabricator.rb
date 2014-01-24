Fabricator(:organization) do
  name { Forgery(:name).company_name }
  website { "http://#{ Forgery(:internet).domain_name }" }
  street { "#{ Forgery(:address).street_name } #{ Forgery(:address).street_number }" }
  place
  email  { Forgery(:internet).email_address }
  phone  { '044 444 44 44' }
end
