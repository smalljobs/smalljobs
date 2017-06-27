class Provider::DashboardsController < ApplicationController

  before_filter :authenticate_provider!

  load_and_authorize_resource :job, through: :current_provider, parent: false

  def show
  end

  protected

  def current_user
    current_provider
  end

end
