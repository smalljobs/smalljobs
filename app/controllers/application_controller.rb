class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def current_user
    current_admin || current_job_broker || current_job_provider || current_job_seeker
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(JobBroker)
      job_brokers_dashboard_path
    elsif resource.is_a?(JobProvider)
      job_providers_dashboard_path
    elsif resource.is_a?(JobSeeker)
      job_seekers_dashboard_path
    else
      super
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:username, :password, :password_confirmation, :firstname, :lastname, :street, :zip, :city, :date_of_birth, :email, :phone, :mobile, :contact_preference, :contact_availability, :work_categories)
    end
  end

end
