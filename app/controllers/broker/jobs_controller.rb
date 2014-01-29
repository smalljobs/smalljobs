class Broker::JobsController < InheritedResources::Base

  before_filter :authenticate_broker!

  load_and_authorize_resource :job, through: :current_broker, except: :new

  protected

  def permitted_params
    params.permit(job: [:id, :provider_id, :work_category_id, :title, :description, :date_type, :start_date, :end_date, :salary, :salary_type, :manpower, :duration, seeker_ids: []])
  end

end
