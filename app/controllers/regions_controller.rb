class RegionsController < ApplicationController

  def index
    @organizations = Organization.all
  end

  def show
    @organization = current_region.organizations.first
    @jobs = current_region.jobs.where(state: 'public')
    @region = current_region
  end

  def current_user
  end
end
