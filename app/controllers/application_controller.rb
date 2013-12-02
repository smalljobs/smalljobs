class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    current_admin || current_job_broker || current_job_provider || current_job_seeker
  end

  def after_inactive_sign_up_path_for(resource)
    if !resource.confirmed?
      confirm_path
    elsif !resource.activated?
      activate_path
    else
      super
    end
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(JobBroker)
      job_broker_dashboard
    elsif resource.is_a?(JobProvider)
      job_providers_dashboard
    elsif resource.is_a?(JobSeeker)
      job_seekers_dashboard
    else
      super
    end
  end

end
