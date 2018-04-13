class Broker::OrganizationsController < InheritedResources::Base

  before_filter :authenticate_broker!
  before_filter :find_organization

  load_and_authorize_resource

  actions :edit, :update

  def update
    if !@organization.update(permitted_params[:organization])
      redirect_to edit_broker_organization_path, flash: {error: @organization.errors.full_messages[0]}
    else
      redirect_to edit_broker_organization_path, notice: "Organisation gespeichert"
    end
  end

  protected

  # Returns currently signed in broker
  #
  # @return [Broker] currently signed in broker
  #
  def current_user
    current_broker
  end

  def find_organization
    @organization = current_region.organizations.first
  end

  def permitted_params
    params.permit(organization: [:opening_hours, :id, :logo, :logo_delete, :background, :background_delete, :name, :description, :website, :street, :email, :phone, :default_hourly_per_age, :place])
  end

end

