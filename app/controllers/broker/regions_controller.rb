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

      location_ids = params[:region][:ji_location_id].split(',').reject(&:blank?).map(&:strip)
      location_names = []
      @ji_locations.each do |name, id|
        location_names << name if location_ids.include?(id.to_s)
      end
      if params[:region][:ji_location_id].blank?
        params[:region][:ji_location_name] = nil
      else
        params[:region][:ji_location_name] = location_names.join(',')
      end
    end

    set_default_rules
    set_default_detail_link

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

  def set_default_detail_link
    params[:region][:detail_link] = 'www.smalljobs.ch/jugendschutz' if params[:region][:detail_link].blank?
  end

  def set_default_rules
    job_contract = ActionController::Base.new.render_to_string(
      template: 'broker/allocations/default_text.html.erb'
    )

    provider_contract = ActionController::Base.new.render_to_string(
      template: 'broker/providers/default_text.html.erb', locals: { organization: @region.organizations.distinct.first }
    )

    params[:region][:job_contract_rules] = job_contract if params[:region][:job_contract_rules].blank?
    params[:region][:provider_contract_rules] = provider_contract if params[:region][:provider_contract_rules].blank?
  end

  # Returns currently signed in broker
  #
  # @return [Broker] currently signed in broker
  #
  def current_user
    current_broker
  end

  def permitted_params
    params.require(:region).permit(
      :name, :logo, :content, :contact_content, :ji_location_id, :ji_location_name, :job_contract_rules,
      :provider_contract_rules, :detail_link
    )
  end

end

