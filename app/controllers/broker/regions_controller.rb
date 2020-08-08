class Broker::RegionsController < InheritedResources::Base

  before_filter :authenticate_broker!

  # actions :edit, :update
  load_and_authorize_resource :region

  def edit
    @organizations = @region.organizations.distinct
    @brokers = @region.brokers.distinct
    @places = @region.places.distinct
  end

  def update
    if !@region.update(permitted_params)
      redirect_to edit_broker_region_path, flash: {error: @region.errors.full_messages[0]}
    else
      redirect_to edit_broker_region_path, notice: "Region gespeichert"
    end
  end

  def destroy_logo
    @region.remove_logo!
  end
  protected

  # Returns currently signed in broker
  #
  # @return [Broker] currently signed in broker
  #
  def current_user
    current_broker
  end

  def permitted_params
    params.require(:region).permit(:name, :logo, :content, :contact_content)
  end

end

