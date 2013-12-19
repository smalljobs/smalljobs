class BrokerDashboardController < ApplicationController

  before_filter :authenticate_job_broker!

  def index
    @providers = current_job_broker.providers
    @seekers   = current_job_broker.seekers
  end

end
