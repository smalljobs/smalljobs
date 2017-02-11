class Broker::DashboardsController < ApplicationController

  before_filter :authenticate_broker!

  load_and_authorize_resource :job, through: :current_region
  load_and_authorize_resource :provider, through: :current_region
  load_and_authorize_resource :seeker, through: :current_region
  # load_and_authorize_resource :assignment, through: :current_region

  def show
    @jobs = current_broker.jobs
    @providers = current_broker.providers
    @seekers = current_broker.seekers
    @assignments = current_broker.assignments
  end

  protected

  def current_user
    current_broker
  end

end
