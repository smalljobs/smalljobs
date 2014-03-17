class Seeker::JobsController < InheritedResources::Base

  before_filter :authenticate_seeker!

  load_and_authorize_resource :job, through: :current_region
  skip_authorize_resource :job, only: :new
  actions :index, :show

  protected

  def current_user
    current_seeker
  end

end
