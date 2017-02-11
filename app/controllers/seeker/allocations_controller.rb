class Seeker::AllocationsController < InheritedResources::Base

  before_filter :authenticate_seeker!

  belongs_to :job

  load_and_authorize_resource :job
  load_and_authorize_resource :allocation, through: :job
  skip_authorize_resource :allocation, only: [:new, :create]

  actions :index

  def create
    @allocation = Allocation.new(permitted_params[:allocation])
    @allocation.seeker = current_seeker
    @allocation.state = 'application_open'

    authorize!(:create, @allocation)
    @allocation.save!
    redirect_to seeker_dashboard_path
  end

  def destroy
    @allocation.state = 'application_rejected'
    @allocation.save!
    redirect_to seeker_dashboard_path
  end

  protected

  def current_user
    current_seeker
  end

  def permitted_params
    params.permit(allocation: [:id, :job_id, :seeker_id, :seeker_feedback])
  end
end
