class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  def current_user
    current_admin || current_job_broker || current_job_provider || current_job_seeker
  end

  def after_inactive_sign_up_path_for(resource)
    if !resource.confirmed?
      awaiting_confirmation_path
    elsif !resource.active?
      awaiting_activation_path
    else
      super
    end
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

end
