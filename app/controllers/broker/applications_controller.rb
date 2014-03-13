class Broker::ApplicationsController < InheritedResources::Base

  before_filter :authenticate_broker!

  belongs_to :job

  load_and_authorize_resource :job
  load_and_authorize_resource :proposal, through: :job

  actions :all, except: [:new, :create, :show]

  protected

  def current_user
    current_broker
  end

  def permitted_params
    params.permit(proposal: [:id, :job_id, :seeker_id, :message])
  end
end
