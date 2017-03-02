class SessionsController < Devise::SessionsController
  before_filter :configure_permitted_parameters

  def new
    # p = params
    # r = resource_name
    super
  end

  def create
    login = params[:provider][:login]
    password = params[:provider][:password]

    provider = Provider.where(["lower(email) = :email OR mobile = :mobile", {email: login.downcase, mobile: "+41#{login}"}]).first
    broker = Broker.where(["lower(email) = :email OR mobile = :mobile", {email: login.downcase, mobile: "+41#{login}"}]).first
    # seeker = Seeker.where(["lower(login) = :value", { :value => login.downcase }]).first
    admin = Admin.where(email: login.downcase).first

    authenticated = false

    if provider != nil
      resource_name = :provider
      self.resource = provider

      if provider.valid_password?(password)
        authenticated = true
      end
    elsif broker != nil
      resource_name = :broker
      self.resource = broker

      if broker.valid_password?(password)
        authenticated = true
      end
    elsif admin != nil
      resource_name = :admin
      self.resource = admin

      if admin.valid_password?(password)
        authenticated = true
      end
    end

    if !authenticated
      flash[:error_info] = I18n.t('common.invalid_username_or_password')
      return redirect_to global_sign_in_path
    end

    sign_in(resource_name, self.resource)
    respond_with self.resource, location: after_sign_in_path_for(self.resource)
  end

  def destroy
    super
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) do |u|
      u.permit(:phone, :email, :password, :password_confirmation, :remember_me)
    end
    # added_attrs = [:phone, :email, :password, :password_confirmation, :remember_me]
    # devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    # devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
