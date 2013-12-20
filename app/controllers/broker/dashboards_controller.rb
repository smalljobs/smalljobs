class Broker::DashboardsController < ApplicationController

  before_filter :authenticate_job_broker!

  def show
    @providers = current_job_broker.providers
    @seekers   = current_job_broker.seekers
  end

end
