class Seeker::ReviewsController < InheritedResources::Base

  before_filter :authenticate_seeker!

  belongs_to :job

  load_and_authorize_resource :job
  load_and_authorize_resource :review, through: :job

  skip_authorize_resource :review, only: :new

  actions :all, except: [:show]

  protected

  def current_user
    current_seeker
  end

  def permitted_params
    params.permit(review: [:id, :job_id, :provider_id, :rating, :message])
  end
end
