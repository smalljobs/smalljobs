class RegionsController < ApplicationController

  def index
    @organizations = Organization.all
  end

  def show
    if current_provider != nil
      redirect_to provider_dashboard_path
      return
    end

    if current_broker != nil
      redirect_to broker_dashboard_path
      return
    end

    @organization = current_region.organizations.first
    @jobs = current_region.jobs.where(state: 'public')
    @region = current_region
  end

  def current_user
  end
end
