class Broker::StatisticsController < InheritedResources::Base

  before_filter :authenticate_broker!, except: [:agreement]

  def index
    jobs = current_broker.jobs.where(state: 'finished').includes(:provider, :organization).group('jobs.id').order(:last_change_of_state).reverse_order()
    allocations = Allocation.where(job: jobs).includes(:seeker)
    @jobs = jobs.length
    @allocations = []
    allocations.each do |allocation|
      @allocations[allocation.job_id] = [] if @allocations[allocation.job_id].nil?
      @allocations[allocation.job_id][Allocation.states[allocation.state]] = [] if @allocations[allocation.job_id][Allocation.states[allocation.state]].nil?
      @allocations[allocation.job_id][Allocation.states[allocation.state]].push(allocation)
    end
    @allocations = allocations.length
    @providers = current_broker.providers.where.not(state: 3).includes(:place, :jobs, :organization).group('providers.id').order(:updated_at).length
    @seekers = current_broker.seekers.where.not(status: 3).includes(:place, :organization).group('seekers.id').order(:updated_at).length

    @seekers = current_broker.seekers.where.not(status: 3).includes(:place, :organization).group('seekers.id').order(:updated_at).map(&:organization_id).uniq
    @assignments = current_broker.assignments.where(job: jobs).includes(:seeker, :provider).group('assignments.id').order(:created_at).length
  end

  def organization_statistics
    if params[:organization_id] == '0'
      organization_id = current_broker.all_organizations.pluck :id
    else
      organization_id = params[:organization_id]
    end

    jobs = current_broker.jobs.where(state: 'finished', organization_id: organization_id)
               .includes(:provider, :organization).group('jobs.id').order(:last_change_of_state).reverse_order()
    allocations = Allocation.where(job: jobs).includes(:seeker)
    @jobs = jobs.length
    @allocations = []
    allocations.each do |allocation|
      @allocations[allocation.job_id] = [] if @allocations[allocation.job_id].nil?
      @allocations[allocation.job_id][Allocation.states[allocation.state]] = [] if @allocations[allocation.job_id][Allocation.states[allocation.state]].nil?
      @allocations[allocation.job_id][Allocation.states[allocation.state]].push(allocation)
    end
    @allocations = allocations.length
    @providers = current_broker.providers.where.not(state: 3).where(organization_id: organization_id).includes(:place, :jobs, :organization).group('providers.id').order(:updated_at).length
    @seekers = current_broker.seekers.where.not(status: 3).where(organization_id: organization_id).includes(:place, :organization).group('seekers.id').order(:updated_at).length
    @assignments = current_broker.assignments.where(job: jobs).includes(:seeker, :provider).group('assignments.id').order(:created_at).length
    debugger
    render json: stats
  end

  protected

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
