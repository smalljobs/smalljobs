class Broker::OrganizationsController < InheritedResources::Base

  before_filter :authenticate_broker!
  before_filter :find_organization

  load_and_authorize_resource

  actions :edit, :update

  def update
    update! { broker_dashboard_url }
  end

  protected

  def current_user
    current_broker
  end

  def find_organization
    @organization = current_region.organizations.first
  end

  def permitted_params
    params.permit(organization: [:id, :logo, :background, :name, :description, :website, :street, :email, :phone, :default_hourly_per_age, :place])
  end

end

