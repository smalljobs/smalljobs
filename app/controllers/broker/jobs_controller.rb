class Broker::JobsController < InheritedResources::Base

  before_filter :authenticate_broker!

  load_and_authorize_resource :job, through: :current_region
  skip_authorize_resource :job, only: :new
  custom_actions resource: :activate

  has_scope :without_applications, type: :boolean

  def create
    @job = Job.new(permitted_params[:job])
    @job.state  = 'available'

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
    params.permit(job: [:id, :provider_id, :work_category_id, :state, :title, :description, :date_type, :start_date, :end_date, :salary, :salary_type, :manpower, :duration, seeker_ids: []])
  end

end
