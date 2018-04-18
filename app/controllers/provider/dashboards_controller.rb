class Provider::DashboardsController < ApplicationController

  before_filter :authenticate_provider!

  load_and_authorize_resource :job, through: :current_provider, parent: false

  def show
  end

  def contract
    require 'rqrcode'
    @provider = current_provider
    @qrcode = RQRCode::QRCode.new(@provider.id.to_s, mode: :number).as_png
    @letter_msg = Mustache.render(@provider.organization.welcome_letter_employers_msg, provider_first_name: @provider.firstname, provider_last_name: @provider.lastname)
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
