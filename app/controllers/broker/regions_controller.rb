class Broker::RegionsController < InheritedResources::Base

  before_filter :authenticate_broker!

  # actions :edit, :update
  load_and_authorize_resource :region

  CURRENT_LINK = "#{ENV['JUGENDAPP_URL']}/api/ji/sites"

  def edit
    if ENV['JI_ENABLED']
      response = RestClient.get CURRENT_LINK, {Authorization: "Bearer #{ENV['JUGENDAPP_TOKEN']}"}
      @ji_locations = [["Keiner", nil]]
      @ji_locations += JSON.parse(response.body)["data"].map{|x| [x['name'], x['id']]}
    end

    @organizations = @region.organizations.distinct
    @brokers = @region.brokers.distinct
    @places = @region.places.distinct
    gon.content = @region.content
    gon.contact_content = @region.contact_content
  end

  def update
    if ENV['JI_ENABLED']
      response = RestClient.get CURRENT_LINK, {Authorization: "Bearer #{ENV['JUGENDAPP_TOKEN']}"}
      @ji_locations = JSON.parse(response.body)["data"].map{|x| [x['name'], x['id']]}
      @ji_locations.each do |ji|
        if ji[1].to_s == params[:region][:ji_location_id].to_s
          params[:region][:ji_location_name] = ji[0]
        end
      end
      if params[:region][:ji_location_id].blank?
        params[:region][:ji_location_name] = nil
      end
    end

    if !@region.update(permitted_params)
      redirect_to edit_broker_region_path, flash: {error: @region.errors.full_messages[0]}
    else
      redirect_to edit_broker_region_path, notice: "Region gespeichert"
    end
  end

  def destroy_logo
    @region.remove_logo!
  end

  def destroy_header_image
    @region.remove_header_image!
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
    params.require(:region).permit(
      :name, :logo, :content, :contact_content, :ji_location_id, :ji_location_name, :rules, :detail_link
    )
  end

end

