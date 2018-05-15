class Provider::DashboardsController < ApplicationController

  before_filter :authenticate_provider!

  load_and_authorize_resource :job, through: :current_provider, parent: false

  def show
  end

  def contract
    require 'rqrcode'
    @provider = current_provider
    @broker = @provider.organization.brokers.first
    @qrcode = RQRCode::QRCode.new(@provider.id.to_s, mode: :number).as_png
    provider_phone = @provider.mobile.empty? ? @provider.phone : @provider.mobile
    @letter_msg = Mustache.render(@provider.organization.welcome_letter_employers_msg, provider_first_name: @provider.firstname, provider_last_name: @provider.lastname, provider_phone: provider_phone, broker_first_name: @broker.firstname, broker_last_name: @broker.lastname, organization_name: @provider.organization.name, organization_zip: @provider.organization.place.zip, organization_street: @provider.organization.street, organization_place: @provider.organization.places.first.name, organization_phone: @provider.organization.phone, organization_email: @provider.organization.email, link_to_jobboard_list: url_for(root_url()))
    @letter_msg.gsub! "\n", "<br>"
    render pdf: 'contract', template: 'broker/providers/contract.html.erb'
  end

  protected

  # Returns currently signed in provider
  #
  # @return [Provider] currently signed in provider
  #
  def current_user
    current_provider
  end
end
