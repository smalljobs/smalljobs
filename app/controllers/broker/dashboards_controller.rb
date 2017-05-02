class Broker::DashboardsController < ApplicationController

  before_filter :authenticate_broker!

  load_and_authorize_resource :job, through: :current_region
  load_and_authorize_resource :provider, through: :current_region
  load_and_authorize_resource :seeker, through: :current_region

  def show
    @jobs = current_broker.jobs.includes(:provider, :organization)
    @providers = current_broker.providers.includes(:place, :jobs, :organization)
    @seekers = current_broker.seekers.includes(:place, :organization)
    @assignments = current_broker.assignments.includes(:seeker, :provider)
  end

  def save_settings
    current_broker.selected_organization_id = params[:selected_organization_id]
    current_broker.filter = params[:filter]
    current_broker.save!
    render json: {message: 'ok', broker: current_broker.selected_organization_id}
  end

  protected

  def current_user
    current_broker
  end
end
