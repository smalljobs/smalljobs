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
