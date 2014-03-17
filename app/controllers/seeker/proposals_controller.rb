class Seeker::ProposalsController < InheritedResources::Base

  before_filter :authenticate_seeker!

  belongs_to :job

  load_and_authorize_resource :job
  load_and_authorize_resource :proposal, through: :job

  actions :index

  protected

  def current_user
    current_seeker
  end
end
