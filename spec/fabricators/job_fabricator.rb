Fabricator(:job) do
  transient :proposals, :applications, :allocations, :reviews

  provider
  work_category

  state 'created'

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

  after_create do |job, transients|
    if transients[:proposals]
      transients[:proposals].each do |seeker|
        Fabricate(:proposal, job: job, seeker: seeker)
      end
    end

    if transients[:applications]
      transients[:applications].each do |seeker|
        Fabricate(:application, job: job, seeker: seeker)
      end
    end

    if transients[:allocations]
      transients[:allocations].each do |seeker|
        Fabricate(:allocation, job: job, seeker: seeker)
      end
    end

    if transients[:reviews]
      transients[:reviews].each do |seeker|
        Fabricate(:review, job: job, seeker: seeker)
      end
    end
  end
end
