class Broker::DashboardsController < ApplicationController

  before_filter :authenticate_broker!

  load_and_authorize_resource :job, through: :current_region
  load_and_authorize_resource :provider, through: :current_region
  load_and_authorize_resource :seeker, through: :current_region

  def show
    if params[:archive] == true || params[:archive] == 'true'
      @jobs = current_broker.jobs.where(state: 'finished').includes(:provider, :organization).group('jobs.id').order(:last_change_of_state).reverse_order()
      allocations = Allocation.where(job: @jobs).includes(:seeker)
      @allocations = []
      allocations.each do |allocation|
        @allocations[allocation.job_id] = [] if @allocations[allocation.job_id].nil?
        @allocations[allocation.job_id][Allocation.states[allocation.state]] = [] if @allocations[allocation.job_id][Allocation.states[allocation.state]].nil?
        @allocations[allocation.job_id][Allocation.states[allocation.state]].push(allocation)
      end

      @providers = current_broker.providers.where(state: 3).includes(:place, :jobs, :organization).group('providers.id').order(:updated_at).reverse_order()
      @seekers = current_broker.seekers.where(status: 3).includes(:place, :organization).group('seekers.id').order(:updated_at).reverse_order()
      @assignments = current_broker.assignments.where(job: @jobs).includes(:seeker, :provider).group('assignments.id').order(:created_at).reverse_order()
      @todos = Todo.includes(:seeker, :provider, :job, :allocation, :todotype)
                 .includes(
                   seeker: :organization,
                   provider: :organization,
                   job: :organization,
                   allocation: :organization,
                   )
                 .where("seeker_id IN (?) OR provider_id IN (?) OR job_id IN (?) OR allocation_id IN (?)",
                        @seekers.pluck(:id), @providers.pluck(:id), @jobs.pluck(:id), allocations.pluck(:id))
                 .reverse_order()
      return
    end

    @jobs = current_broker.jobs.where.not(state: 'finished').includes(:provider, :organization).group('jobs.id').order(:last_change_of_state).reverse_order()
    allocations = Allocation.where(job: @jobs).includes(:seeker)
    @allocations = []
    allocations.each do |allocation|
      @allocations[allocation.job_id] = [] if @allocations[allocation.job_id].nil?
      @allocations[allocation.job_id][Allocation.states[allocation.state]] = [] if @allocations[allocation.job_id][Allocation.states[allocation.state]].nil?
      @allocations[allocation.job_id][Allocation.states[allocation.state]].push(allocation)
    end

    @providers = current_broker.providers.where.not(state: 3).includes(:place, :jobs, :organization).group('providers.id').order(:updated_at).reverse_order()
    @seekers = current_broker.seekers.where.not(status: 3).includes(:place, :organization).group('seekers.id').order(:updated_at).reverse_order()
    @assignments = current_broker.assignments.where(job: @jobs).includes(:seeker, :provider).group('assignments.id').order(:created_at).reverse_order()
    @todos = Todo.includes(:seeker, :provider, :job, :allocation, :todotype)
                 .includes(
                   seeker: :organization,
                   provider: :organization,
                   job: :organization,
                   allocation: :organization,
                   )
                 .where("seeker_id IN (?) OR provider_id IN (?) OR job_id IN (?) OR allocation_id IN (?)",
                       @seekers.pluck(:id), @providers.pluck(:id), @jobs.pluck(:id), allocations.pluck(:id))
                 .reverse_order()

    @todos_current = @todos.current
    @todos_postponed = @todos.postponed

    if params[:organization_id].blank?
      params[:organization_id] = current_broker&.selected_organization_id
    end

    unless params[:organization_id] == "0"
      @providers = @providers.where(organization_id: params[:organization_id])
      @seekers = @seekers.where(organization_id: params[:organization_id])
      @jobs = @jobs.where(organization_id: params[:organization_id])
      @assignments = @assignments.joins("LEFT JOIN providers as prov ON assignments.provider_id = prov.id").where("prov.organization_id = #{params[:organization_id]}")

      @todos_current = Todo.joins("LEFT JOIN seekers ON seekers.id = todos.seeker_id LEFT JOIN providers ON providers.id = todos.provider_id LEFT JOIN jobs on jobs.id = todos.job_id")
                       .where("seekers.organization_id = ? OR providers.organization_id = ? OR jobs.organization_id = ?", params[:organization_id], params[:organization_id], params[:organization_id])
                        .where(id: @todos_current.map(&:id))

      @todos_postponed = Todo.joins("LEFT JOIN seekers ON seekers.id = todos.seeker_id LEFT JOIN providers ON providers.id = todos.provider_id LEFT JOIN jobs on jobs.id = todos.job_id")
                           .where("seekers.organization_id = ? OR providers.organization_id = ? OR jobs.organization_id = ?", params[:organization_id], params[:organization_id], params[:organization_id])
                            .where(id: @todos_postponed.map(&:id))
    end



    if params[:todo_current_page].blank?
      @todos_current = @todos_current.paginate(page: params[:todos_page], per_page: 15)
    else
      @todos_current = @todos_current.paginate(page: params[:todo_current_page], per_page: 15)
    end

    @todos_postponed = @todos_postponed.paginate(page: params[:todo_postponed_page], per_page: 15 )

    @seekers = @seekers.paginate(page: params[:seekers_page], per_page: 15)
    @providers = @providers.paginate(page: params[:providers_page], per_page: 15)
    @jobs = @jobs.paginate(page: params[:jobs_page], per_page: 15)
    @assignments = @assignments.paginate(page: params[:assignments_page], per_page: 15)


    respond_to do |format|
      format.html
      format.js { render template: '/broker/dashboards/show.js.erb' }
    end

  end

  # Save broker settings from dashboard (current filter and selected organization)
  def save_settings
    current_broker.selected_organization_id = params[:selected_organization_id]
    current_broker.filter = params[:filter]
    current_broker.save!
    render json: {message: 'ok', broker: current_broker.selected_organization_id}
  end

  protected

  # Returns currently signed in broker
  #
  # @return [Broker] currently signed in broker
  #
  def current_user
    current_broker
  end
end
