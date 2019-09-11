class Broker::DashboardsController < ApplicationController

  before_filter :authenticate_broker!

  load_and_authorize_resource :job, through: :current_region
  load_and_authorize_resource :provider, through: :current_region
  load_and_authorize_resource :seeker, through: :current_region

  def show
    if params[:archive] == true || params[:archive] == 'true'
      @jobs = current_broker.jobs.where(state: 'finished').includes(:provider, :organization).group('jobs.id').order(:last_change_of_state).reverse_order()
      allocations = Allocation.where(job: @jobs).includes(:seeker)
      @allocations = {}
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
    @allocations = {}
    allocations.each do |allocation|
      @allocations[allocation.job_id] = [] if @allocations[allocation.job_id].nil?
      @allocations[allocation.job_id][Allocation.states[allocation.state]] = [] if @allocations[allocation.job_id][Allocation.states[allocation.state]].nil?
      @allocations[allocation.job_id][Allocation.states[allocation.state]].push(allocation)
    end

    @providers = current_broker.providers.where.not(state: 3).includes(:place, :jobs, :organization).distinct.order(:updated_at).reverse_order()
    @seekers = current_broker.seekers.where.not(status: 3).includes(:place, :organization).distinct.order(:updated_at).reverse_order()
    @assignments = current_broker.assignments.where(job: @jobs).includes(:seeker, :provider).distinct.order(:created_at).reverse_order()
    @todos = Todo.includes(:seeker, :provider, :job, :allocation, :todotype)
               .includes(
                 seeker: :organization,
                 provider: :organization,
                 job: :organization,
                 allocation: :organization,
                 )
               .where("seeker_id IN (?) OR provider_id IN (?) OR job_id IN (?) OR allocation_id IN (?)",
                      @seekers.map(&:id), @providers.map(&:id), @jobs.map(&:id), allocations.map(&:id))
               .reverse_order()
  end

  # Save broker settings from dashboard (current filter and selected organization)
  #
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
