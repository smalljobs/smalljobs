class Provider::JobsController < InheritedResources::Base

  before_filter :authenticate_provider!

  load_and_authorize_resource :job, through: :current_provider, parent: false
  skip_authorize_resource :job, only: [:new, :create]

  def new
    @job = Job.new(state: 'hidden')
  end

  def create
    @job = Job.new(permitted_params[:job])
    @job.provider = current_provider
    @job.state = 'hidden'

    authorize!(:create, @job)
    create!
  end

  protected

  def current_user
    current_provider
  end

  def permitted_params
    params.permit(job: [:id, :work_category_id, :title, :description, :date_type, :start_date, :end_date, :salary, :salary_type, :manpower, :duration])
  end

end
