class Seeker::AllocationsController < InheritedResources::Base

  before_filter :authenticate_seeker!

  belongs_to :job

  load_and_authorize_resource :job
  load_and_authorize_resource :allocation, through: :job

  actions :index

  protected

  def current_user
    current_seeker
  end
end
