class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  protected

  def current_user
    current_admin || current_broker || current_provider || current_seeker
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(Broker)
      broker_dashboard_path
    elsif resource.is_a?(Provider)
      provider_dashboard_path
    elsif resource.is_a?(Seeker)
      seeker_dashboard_path
    else
      super
    end
  end

end
