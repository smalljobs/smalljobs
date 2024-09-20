class Broker::DashboardsController < ApplicationController

  before_filter :authenticate_broker!

  load_and_authorize_resource :job, through: :current_region
  load_and_authorize_resource :provider, through: :current_region
  load_and_authorize_resource :seeker, through: :current_region

  def jobs_table
    if params[:archive] == true || params[:archive] == 'true'
      set_jobs(true)
      set_allocations(true)
      return
    end
    set_jobs(false)
    set_allocations(false)
  end

  def todos_table
    if params[:archive] == true || params[:archive] == 'true'
      set_jobs(true)
      set_allocations(true)
      set_providers(true)
      set_seekers(true)
      set_todos(true)
      return
    end

    set_jobs(false)
    set_allocations(false)
    set_providers(false)
    set_seekers(false)
    set_todos(false)
  end

  def seekers_table
    current_broker.update_unread_messages
    @unread_messages = current_broker.unread_messages_hash
    if params[:archive] == true || params[:archive] == 'true'
      set_seekers(true)
      return
    end
    set_seekers(false)
  end

  def assignments_table
    if params[:archive] == true || params[:archive] == 'true'
      set_jobs(true)
      set_assignments(true)
      return
    end
    set_jobs(false)
    set_assignments(false)
  end

  def providers_table
    if params[:archive] == true || params[:archive] == 'true'
      set_providers(true)
      return
    end
    set_providers(false)
  end

  def show
    current_broker.update_unread_messages
    @unread_messages = current_broker.unread_messages_hash
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
                   job: :organization
                   ).not_completed
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
                 job: :organization
                 ).not_completed
               .where("seeker_id IN (?) OR provider_id IN (?) OR job_id IN (?) OR allocation_id IN (?)",
                      @seekers.map(&:id), @providers.map(&:id), @jobs.map(&:id), allocations.map(&:id))
               .reverse_order()
  end

  # Save broker settings from dashboard (current filter and selected organization)
  #
  def save_settings
    current_broker.selected_organization_id = params[:selected_organization_id]
    current_broker.filter = params[:filter]
    if current_broker.save
      render json: {message: 'Saved broker settings', broker: current_broker.selected_organization_id}, status: 200
    else
      error = "Can't save broker settings. #{current_broker.errors.full_messages.join(',')}"
      render json: {message: error, broker: current_broker.selected_organization_id}, status: 404
    end
  end

  private

  def set_jobs(is_archive)
    if is_archive
      @jobs = current_broker.jobs.where(state: 'finished').includes(:provider, :organization).group('jobs.id').order(:last_change_of_state).reverse_order()
    else
      @jobs = current_broker.jobs.where.not(state: 'finished').includes(:provider, :organization).group('jobs.id').order(:last_change_of_state).reverse_order()
    end
  end

  def set_allocations(is_archive)
    if is_archive
      allocations = Allocation.where(job: @jobs).includes(:seeker)
      @allocations = {}
      allocations.each do |allocation|
        @allocations[allocation.job_id] = [] if @allocations[allocation.job_id].nil?
        @allocations[allocation.job_id][Allocation.states[allocation.state]] = [] if @allocations[allocation.job_id][Allocation.states[allocation.state]].nil?
        @allocations[allocation.job_id][Allocation.states[allocation.state]].push(allocation)
      end
    else
      allocations = Allocation.where(job: @jobs).includes(:seeker)
      @allocations = {}
      allocations.each do |allocation|
        @allocations[allocation.job_id] = [] if @allocations[allocation.job_id].nil?
        @allocations[allocation.job_id][Allocation.states[allocation.state]] = [] if @allocations[allocation.job_id][Allocation.states[allocation.state]].nil?
        @allocations[allocation.job_id][Allocation.states[allocation.state]].push(allocation)
      end
    end
  end

  def set_providers(is_archive)
    if is_archive
      @providers = current_broker.providers.where(state: 3).includes(:place, :jobs, :organization).group('providers.id').order(:updated_at).reverse_order()
    else
      @providers = current_broker.providers.where.not(state: 3).includes(:place, :jobs, :organization).distinct.order(:updated_at).reverse_order()
    end
  end

  def set_seekers(is_archive)
    if is_archive
      @seekers = current_broker.seekers.where(status: 3).includes(:place, :organization).group('seekers.id').order(:updated_at).reverse_order()
    else
      @seekers = current_broker.seekers.where.not(status: 3).includes(:place, :organization).distinct.order(:updated_at).reverse_order()
    end
  end

  def set_todos(is_archive)
    allocations = Allocation.where(job: @jobs).includes(:seeker)

    if is_archive
      @todos = Todo.includes(:seeker, :provider, :job, :allocation, :todotype)
                .includes(
                  seeker: :organization,
                  provider: :organization,
                  job: :organization
                  ).not_completed
                .where("seeker_id IN (?) OR provider_id IN (?) OR job_id IN (?) OR allocation_id IN (?)",
                        @seekers.pluck(:id), @providers.pluck(:id), @jobs.pluck(:id), allocations.pluck(:id))
                .reverse_order()
    else
      @todos = Todo.includes(:seeker, :provider, :job, :allocation, :todotype)
               .includes(
                 seeker: :organization,
                 provider: :organization,
                 job: :organization
                 ).not_completed
               .where("seeker_id IN (?) OR provider_id IN (?) OR job_id IN (?) OR allocation_id IN (?)",
                      @seekers.map(&:id), @providers.map(&:id), @jobs.map(&:id), allocations.map(&:id))
               .reverse_order()
    end
  end

  def set_assignments(is_archive)
    if is_archive
      @assignments = current_broker.assignments.where(job: @jobs).includes(:seeker, :provider).group('assignments.id').order(:created_at).reverse_order()
    else
      @assignments = current_broker.assignments.where(job: @jobs).includes(:seeker, :provider).distinct.order(:created_at).reverse_order()
    end
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
