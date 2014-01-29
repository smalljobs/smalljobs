Fabricator(:job) do
  provider
  work_category

  state 'created'

  title 'A nice job'
  description 'Help me understand the Internet'

  date_type 'date_range'
  start_date Time.now + 7.days
  end_date Time.now + 14.days

  salary_type 'hourly'
  salary 12.50

  manpower 1
  duration 120
end
