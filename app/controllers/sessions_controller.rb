class SessionsController < Devise::SessionsController
  before_filter :configure_permitted_parameters

  def new
    redirect_to sign_in_path
  end

  def create
    login = params[:provider][:login]
    password = params[:provider][:password]

    provider = Provider.where(['lower(email) = :email OR mobile = :mobile', {email: login.downcase, mobile: "+41#{login}"}]).first
    broker = Broker.where(['lower(email) = :email OR mobile = :mobile', {email: login.downcase, mobile: "+41#{login}"}]).first
    # seeker = Seeker.where(["lower(login) = :value", { :value => login.downcase }]).first
    admin = Admin.where(email: login.downcase).first

    authenticated = false

    if !provider.nil?
      resource_name = :provider
      self.resource = provider

      if provider.valid_password?(password)
        authenticated = true
      end
    elsif !broker.nil?
      resource_name = :broker
      self.resource = broker

      if broker.valid_password?(password)
        Rails.logger.info "\n\n\n\n\n-------------------"
        broker.create_rc_account
        Rails.logger.info "-------------------\n\n\n\n\n"
        if broker.regions.pluck(:id).include?(current_region.id)
          authenticated = true
        else
          flash[:error_info] = I18n.t('common.invalid_subdomain')
          return redirect_to global_sign_in_path
        end
      end
    elsif !admin.nil?
      resource_name = :admin
      self.resource = admin

      if admin.valid_password?(password)
        authenticated = true
      end
    end

    unless authenticated
      flash[:error_info] = I18n.t('common.invalid_username_or_password')
      return redirect_to global_sign_in_path
    end

    sign_in(resource_name, resource)
    flash[:notice] = nil
    redirect_to after_sign_in_path_for(resource)
  end

  def destroy
    super
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in) do |u|
      u.permit(:phone, :email, :password, :password_confirmation, :remember_me)
    end
    # added_attrs = [:phone, :email, :password, :password_confirmation, :remember_me]
    # devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    # devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
