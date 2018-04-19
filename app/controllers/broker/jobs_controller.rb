class Broker::JobsController < InheritedResources::Base

  before_filter :authenticate_broker!

  load_and_authorize_resource :job, through: :current_region
  skip_authorize_resource :job, only: :new
  custom_actions resource: :activate

  has_scope :without_applications, type: :boolean

  def show
    redirect_to edit_broker_job_path(@job)
  end

  def index
    redirect_to broker_dashboard_path + "#jobs"
  end

  def new
    @job = Job.new()
    @job.created_at = DateTime.now()
    @job.state = 'hidden'
    @job.provider_id = params[:provider_id] unless params[:provider_id].nil?
  end

  def create
    @job = Job.new(permitted_params[:job])

    create!
  end

  def activate
    authorize! :activate, @job

    activate! do
      @job.update_attribute(:state, 'available')
    end
  end

  def delete
    Todo.where(job_id: @job.id).find_each(&:destroy!)

    Allocation.where(job_id: @job.id).find_each(&:destroy!)

    Assignment.where(job_id: @job.id).find_each(&:destroy!)


    @job.destroy!

    render json: { message: 'Job deleted' }, status: 200
  end

  protected

  # Returns currently signed in broker
  #
  # @return [Broker] currently signed in broker
  #
  def current_user
    current_broker
  end

  def permitted_params
    params.permit(job: [:current_broker_id, :new_note, :id, :provider_id, :work_category_id, :state, :title, :long_description, :short_description, :date_type, :start_date, :end_date, :salary, :salary_type, :manpower, :duration, :notes, :organization_id, seeker_ids: []])
  end

end
