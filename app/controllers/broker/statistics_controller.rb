class Broker::StatisticsController < InheritedResources::Base

  before_filter :authenticate_broker!, except: [:agreement]

  def index
    all_organizations = current_broker.all_organizations.pluck(:id)
    get_statistic_by_organization_and_date(all_organizations)
  end

  def organization_statistics
    organization = params[:organization_id] == '0' ? current_broker.all_organizations.pluck(:id) : params[:organization_id]
    get_statistic_by_organization_and_date(organization, params[:start_date], params[:end_date])
    render json: stats
  end

  protected

  def get_date_range date_start, date_end
    # if nil, past date is taken for date_start, Today for date end, else dates are provided
    date_start = (Date.today - 1000.months) if date_start.blank?
    date_end = Date.today if date_end.blank?
    (date_start.to_date..date_end.to_date)
  end

  # getting all infos (based on method in dashboard - index) taken by organization and date range
  def get_statistic_by_organization_and_date organization, date_start = nil, date_end = nil
    date_range = get_date_range(date_start, date_end)
    jobs = current_broker.jobs
               .where(state: 'finished', organization_id: organization)
               .where(created_at: date_range)
               .includes(:provider, :organization)
               .group('jobs.id')
               .order(:last_change_of_state).reverse_order()
    allocations = Allocation
                      .where(job: jobs)
                      .where(created_at: date_range)
                      .includes(:seeker)
    @jobs = jobs.length
    @allocations = []
    allocations.each do |allocation|
      @allocations[allocation.job_id] = [] if @allocations[allocation.job_id].nil?
      @allocations[allocation.job_id][Allocation.states[allocation.state]] = [] if @allocations[allocation.job_id][Allocation.states[allocation.state]].nil?
      @allocations[allocation.job_id][Allocation.states[allocation.state]].push(allocation)
    end
    @allocations = allocations.length
    @providers = current_broker.providers
                     .where.not(state: 3)
                     .where(organization_id: organization)
                     .where(created_at: date_range)
                     .includes(:place, :jobs, :organization)
                     .group('providers.id')
                     .order(:updated_at).length
    @seekers = current_broker.seekers
                     .where.not(status: 3)
                     .where(organization_id: organization)
                     .where(created_at: date_range)
                     .includes(:place, :organization)
                     .group('seekers.id')
                     .order(:updated_at).length
    @assignments = current_broker.assignments
                     .where(job: jobs)
                     .where(start_time: date_range)
                     .includes(:seeker, :provider)
                     .group('assignments.id')
                     .order(:created_at).length
  end

  # date stats, if we gonna have more charts, need to create a service which take type of chart and gather proper data.
  # Then return proper json. But we need more info about layout
  def stats
     [{
      label: 'Organizatione',
      backgroundColor: [
          'rgba(255, 99, 132, 0.2)',
          'rgba(54, 162, 235, 0.2)',
          'rgba(255, 206, 86, 0.2)',
          'rgba(75, 192, 192, 0.2)',
          'rgba(153, 102, 255, 0.2)',
      ],
      borderColor: [
          'rgba(255, 99, 132, 1)',
          'rgba(54, 162, 235, 1)',
          'rgba(255, 206, 86, 1)',
          'rgba(75, 192, 192, 1)',
          'rgba(153, 102, 255, 1)',
      ],
      borderWidth:1,
      data: ["#{@seekers}", "#{@providers}", "#{@assignments}", "#{@allocations}", "#{@jobs}"]
    }]
  end

  def current_user
    current_broker
  end

end
