class Broker::JobsController < InheritedResources::Base

  before_filter :authenticate_broker!

  load_and_authorize_resource :job, through: :current_region
  skip_authorize_resource :job, only: :new
  custom_actions resource: :activate

  has_scope :without_applications, type: :boolean

  def show
    redirect_to request.referer
  end

  def index
    redirect_to broker_dashboard_path + "#jobs"
  end

  def new
    @job = Job.new()
    @job.created_at = DateTime.now()
    @job.state  = 'hidden'
  end

  def create
    @job = Job.new(permitted_params[:job])
    # @job.state  = 'hidden'

    create!
  end

  def activate
    authorize! :activate, @job

    activate! do
      @job.update_attribute(:state, 'available')
    end
  end

  protected

  def current_user
    current_broker
  end

  def permitted_params
    params.permit(job: [:id, :provider_id, :work_category_id, :state, :title, :long_description, :short_description, :date_type, :start_date, :end_date, :salary, :salary_type, :manpower, :duration, :notes, :organization_id, seeker_ids: []])
  end

end
