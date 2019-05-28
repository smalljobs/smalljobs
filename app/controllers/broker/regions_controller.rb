class Broker::RegionsController < InheritedResources::Base

  before_filter :authenticate_broker!

  actions :edit, :update
  load_and_authorize_resource

  def edit
    @region = current_region
    @organizations = @region.organizations
    @brokers = @region.brokers
    @places = @region.places
  end
  # def update
  #   if !@organization.update(permitted_params[:organization])
  #     redirect_to edit_broker_organization_path, flash: {error: @organization.errors.full_messages[0]}
  #   else
  #     redirect_to edit_broker_organization_path, notice: "Organisation gespeichert"
  #   end
  # end

  protected

  # Returns currently signed in broker
  #
  # @return [Broker] currently signed in broker
  #
  def current_user
    current_broker
  end

  def permitted_params
  end

end

