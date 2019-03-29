class Broker::JobsController < InheritedResources::Base

  before_filter :authenticate_broker!

  before_action :redirect_not_found, only: [:edit, :show]
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

  def edit
    edit!
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

  # Adds new comment for seeker
  #
  def add_comment
    comment = params[:comment]
    Note.create!(job_id: @job.id, broker_id: current_broker.id, message: comment)
  end

  # Remove broker comment from seeker
  #
  def remove_comment
    id = params[:note_id]
    note = Note.find_by(id: id)
    if note.nil? || note.broker.id != current_broker.id || note.job.id != @job.id
      return
    end

    note.destroy!
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
    params.permit(job: [:current_broker_id, :id, :provider_id, :work_category_id, :state, :title, :long_description, :short_description, :date_type, :start_date, :end_date, :salary, :salary_type, :manpower, :duration, :notes, :organization_id, seeker_ids: []])
  end

  def redirect_not_found
    job = Job.find_by(id: params[:id])
    if job.nil?
      redirect_to broker_dashboard_path + "#jobs"
      return false
    end
  end
end
