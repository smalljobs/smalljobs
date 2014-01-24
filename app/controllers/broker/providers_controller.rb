class Broker::ProvidersController < InheritedResources::Base

  before_filter :authenticate_broker!
  before_filter :optional_password, only: [:update]

  load_and_authorize_resource :provider, through: :current_broker

  protected

  def optional_password
    if params[:provider][:password].blank?
      params[:provider].delete(:password)
      params[:provider].delete(:password_confirmation)
    end
  end

  def permitted_params
    params.permit(provider: [:id, :username, :password, :password_confirmation, :firstname, :lastname, :street, :place_id, :email, :phone, :mobile, :contact_preference, :contact_availability, :active, :confirmed])
  end

end
