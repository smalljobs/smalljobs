class Seeker::ApplicationsController < InheritedResources::Base

  before_filter :authenticate_seeker!

  belongs_to :job

  load_and_authorize_resource :job
  load_and_authorize_resource :application, through: :job

  skip_authorize_resource :application, only: :new

  actions :all, except: [:show]

  protected

  def current_user
    current_seeker
  end

  def permitted_params
    params.permit(application: [:id, :job_id, :seeker_id, :message])
  end
end
