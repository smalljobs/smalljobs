class Broker::ProvidersController < InheritedResources::Base

  before_filter :authenticate_broker!
  before_filter :optional_password, only: [:update]

  load_and_authorize_resource :provider, through: :current_region, except: :new

  def index
    redirect_to broker_dashboard_path + '#providers'
  end

  def show
    redirect_to request.referer
  end

  def new
    @provider = Provider.new
    @provider.active = false
    @provider.contract = false
    @provider.place = current_region.places.order(:name, :zip).first
  end

  def create
    @provider = Provider.new(permitted_params[:provider])
    @provider.terms = '1'

    create! do |success, failure|
      success.html {redirect_to edit_broker_provider_path(@provider), notice: "Anbieter erstellt"}
    end
  end

  def contract
    require 'rqrcode'
    @qrcode = RQRCode::QRCode.new(@provider.id.to_s, mode: :number).as_png
    render pdf: 'contract', template: 'broker/providers/contract.html.erb'
  end

  def delete
    Todo.where(provider_id: @provider.id).find_each(&:destroy!)

    Job.where(provider_id: @provider.id).find_each do |job|
      Allocation.where(job_id: job.id).find_each(&:destroy!)

      Assignment.where(job_id: job.id).find_each(&:destroy!)

      job.destroy!
    end

    Assignment.where(provider_id: @provider.id).find_each(&:destroy!)


    @provider.destroy!

    render json: {message: 'Provider deleted'}, status: 200
  end

  protected

  def current_user
    current_broker
  end

  def optional_password
    return unless params[:provider][:password].blank?
    params[:provider].delete(:password)
    params[:provider].delete(:password_confirmation)
  end

  def permitted_params
    params.permit(provider: %i[id username password password_confirmation firstname lastname street place_id email phone mobile contact_preference contact_availability active confirmed organization_id notes company state contract])
  end

end
