Fabricator(:job) do
  transient :allocations

  provider
  work_category

  state 'public'

  title 'A nice job'
  short_description 'Help me understand the Internet'
  long_description 'Help me understand the Internet'

  date_type 'date_range'
  start_date Time.now + 7.days
  end_date Time.now + 14.days

  salary_type 'hourly'
  salary 12.50

  manpower 1
  duration 120

  organization

  after_create do |job, transients|
    if transients[:allocations]
      transients[:allocations].each do |seeker|
        Fabricate(:allocation, job: job, seeker: seeker, provider: job.provider)
      end
    end
  end
end
