class Provider::DashboardsController < ApplicationController

  before_filter :authenticate_provider!

  def show
  end

  protected

  def current_user
    current_provider
  end

end
