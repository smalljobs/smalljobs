class Broker::DashboardsController < ApplicationController

  before_filter :authenticate_broker!

  def show
  end

  protected

  def current_user
    current_broker
  end

end
