class RegistrationsController < Devise::RegistrationsController

  before_filter :configure_permitted_parameters

  def new
    if self.resource_name == :broker
      flash[:alert] = t('devise_views.no_broker_registration')
      redirect_to root_path
    else
      super
    end
  end

  def after_sign_up_path_for(resource)
    case resource
      # when Broker
      #   broker_dashboard_url(subdomain: ensure_subdomain_for(resource))
      when Provider
        new_provider_job_url(subdomain: ensure_subdomain_for(resource))
      when Seeker
        seeker_dashboard_url(subdomain: ensure_subdomain_for(resource))
      # when Admin
      #   rails_admin.dashboard_url(subdomain: request.subdomain)
      else
        super
    end
  end

  def after_inactive_sign_up_path_for(resource)
    case resource
      # when Broker
      #   broker_dashboard_url(subdomain: ensure_subdomain_for(resource))
      # when Provider
      #   provider_dashboard_url(subdomain: ensure_subdomain_for(resource))
      when Seeker
        seeker_dashboard_url(subdomain: ensure_subdomain_for(resource))
      # when Admin
      #   rails_admin.dashboard_url(subdomain: request.subdomain)
      else
        super
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:login, :password, :password_confirmation, :firstname, :lastname, :street, :place_id, :date_of_birth, :sex, :email, :phone, :mobile, :contact_preference, :contact_availability, :terms, :organization_id, work_category_ids: [])
    end

    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:login, :password, :password_confirmation, :current_password, :firstname, :lastname, :street, :place_id, :date_of_birth, :sex, :email, :phone, :mobile, :contact_preference, :contact_availability, :terms, :organization_id, work_category_ids: [])
    end
  end

end
