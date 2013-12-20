class Broker::DashboardsController < ApplicationController

  before_filter :authenticate_broker!

  def show
    @providers = current_broker.providers
    @seekers   = current_broker.seekers
  end

end
