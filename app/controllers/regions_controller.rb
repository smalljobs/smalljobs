class RegionsController < ApplicationController

  def index
    @organizations = Organization.all
  end

  def show
    @organization = current_region.organizations.first
  end

end
