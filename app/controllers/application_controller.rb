class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  protected

  def current_user
    current_admin || current_job_broker || current_job_provider || current_job_seeker
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(JobBroker)
      broker_dashboard_path
    elsif resource.is_a?(JobProvider)
      provider_dashboard_path
    elsif resource.is_a?(JobSeeker)
      seeker_dashboard_path
    else
      super
    end
  end

end
