class Broker::ProvidersController < InheritedResources::Base

  before_filter :authenticate_broker!
  before_filter :optional_password, only: [:update]

  load_and_authorize_resource :provider, through: :current_region, except: :new

  def show
    redirect_to broker_dashboard_url
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
    params.permit(provider: [:id, :username, :password, :password_confirmation, :firstname, :lastname, :street, :place_id, :email, :phone, :mobile, :contact_preference, :contact_availability, :active, :confirmed, :organization_id, :notes])
  end

end
