Fabricator(:admin) do
  email     { Forgery(:internet).email_address }
  password  { Forgery(:basic).password.rjust(10, 'a') }
end
