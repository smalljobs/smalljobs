class Broker::ProvidersController < InheritedResources::Base

  before_filter :authenticate_broker!
  before_filter :optional_password, only: [:update]

  load_and_authorize_resource :provider, through: :current_region, except: :new

  def index
    redirect_to broker_dashboard_path
  end

  def show
    redirect_to request.referer
  end

  def new
    @provider = Provider.new()
    @provider.active = false
    @provider.contract = false
  end

  def create
    @provider = Provider.new(permitted_params[:provider])
    @provider.terms = '1'

    create!
  end

  def contract
    require 'rqrcode'
    @qrcode = RQRCode::QRCode.new("#{@provider.id}", mode: :number).as_png
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "contract", template: 'broker/providers/contract.html.erb'
      end
    end
  end

  protected

  def current_user
    current_broker
  end

  def optional_password
    if params[:provider][:password].blank?
      params[:provider].delete(:password)
      params[:provider].delete(:password_confirmation)
    end
  end

  def permitted_params
    params.permit(provider: [:id, :username, :password, :password_confirmation, :firstname, :lastname, :street, :place_id, :email, :phone, :mobile, :contact_preference, :contact_availability, :active, :confirmed, :organization_id, :notes, :company])
  end

end
