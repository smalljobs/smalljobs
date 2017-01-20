class Broker::AllocationsController < InheritedResources::Base

  before_filter :authenticate_broker!

  belongs_to :job

  load_and_authorize_resource :job
  load_and_authorize_resource :allocation, through: :job

  skip_authorize_resource :allocation, only: :new

  actions :all, except: [:show]

  protected

  def current_user
    current_broker
  end

  def permitted_params
    params.permit(allocation: [:id, :job_id, :seeker_id, :state, :feedback_seeker, :feedback_provider, :contract_returned])
  end
end
