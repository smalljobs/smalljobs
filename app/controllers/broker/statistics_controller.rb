class Broker::StatisticsController < InheritedResources::Base

  before_filter :authenticate_broker!, except: [:agreement]

  def index
  end

  def organization_statistics
    params[:region_id] = current_region.id
    organization = params[:organization_id] == '0' ? current_broker.all_organizations.pluck(:id) : [params[:organization_id]]
    data = ::Statistics::GenerateDataForChart.new(get_date_range, organization, options).call
    render json: {statistic: data[:datasets], label: data[:labels]}
  end

  protected

  def options
    params.permit(:interval, :sum_type, :region_id)
  end

  def get_date_range
    lowest_date = [Seeker, Provider, Job].map{|x| x.order(created_at: :asc).first.created_at}.sort.first.to_date
    [
        params[:start_date].present? ? params[:start_date].to_date : lowest_date,
        params[:end_date].present? ? params[:end_date].to_date : Date.today
    ]
  end

  # getting all infos (based on method in dashboard - index) taken by organization and date range
  def get_statistic_by_organization_and_date organization, date_start = nil, date_end = nil
    date_range = get_date_range
    jobs = current_broker.jobs
               .where(state: 'finished', organization_id: organization)
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
                     .group('assignments.id')
                     .order(:created_at).length
  end


  def current_user
    current_broker
  end

end
