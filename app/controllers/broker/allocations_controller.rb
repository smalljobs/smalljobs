class Broker::AllocationsController < InheritedResources::Base

  before_filter :authenticate_broker!

  belongs_to :job

  # load_and_authorize_resource :job
  # load_and_authorize_resource :allocation, through: :job

  skip_authorize_resource :allocation, only: :new

  actions :all

  def show
    @job = Job.find_by(id: params[:job_id])
    if params[:seeker_id] != nil
      @allocation = Allocation.new(job_id: @job.id, seeker_id: params[:seeker_id], state: :application_open)
      @allocation.save!
    else
      @allocation = Allocation.find_by(id: params[:id])
    end
  end

  protected

  def current_user
    current_broker
  end

  def permitted_params
    params.permit(allocation: [:id, :job_id, :seeker_id, :state, :feedback_seeker, :feedback_provider, :contract_returned])
  end
end
