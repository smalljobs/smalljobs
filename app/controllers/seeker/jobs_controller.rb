class Seeker::JobsController < InheritedResources::Base

  before_filter :authenticate_seeker!

  load_and_authorize_resource :job, through: :current_region
  skip_authorize_resource :job, only: :new
  actions :index, :show
  load_and_authorize_resource :allocation, through: :job

  def show
    @allocation = Allocation.where(seeker_id: current_seeker.id, job_id: @job.id).first
    if @allocation == nil
      @allocation = Allocation.new
    end
  end

  protected

  def current_user
    current_seeker
  end

end
