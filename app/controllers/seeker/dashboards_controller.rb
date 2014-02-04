class Seeker::DashboardsController < ApplicationController

  before_filter :authenticate_seeker!

  def show
  end

  protected

  def current_user
    current_seeker
  end

end
