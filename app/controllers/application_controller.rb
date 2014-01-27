require 'app_responder'

class ApplicationController < ActionController::Base

  self.responder = AppResponder
  respond_to :html, :json

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    referer = request.env['HTTP_REFERER']

    if referer.present? && referer != request.env['REQUEST_URI']
      redirect_to(referer, alert: exception.message)
    else
      redirect_to(root_url, alert: exception.message)
    end
  end

  helper_method :current_region

  protected

  def current_user
    current_admin || current_broker || current_provider || current_seeker
  end

  def current_region
    @region ||= Region.find_by_subdomain(request.subdomain)
  end

  def after_sign_in_path_for(resource)
    case resource
    when Broker
      broker_dashboard_url(subdomain: ensure_subdomain_for(resource))
    when Provider
      provider_dashboard_url(subdomain: ensure_subdomain_for(resource))
    when Seeker
      seeker_dashboard_url(subdomain: ensure_subdomain_for(resource))
    else
      super
    end
  end

  private

  def ensure_subdomain_for(resource)
    case resource
    when Broker
      subdomains = resource.regions.pluck(:subdomain)
      subdomains.include?(request.subdomain) ? request.subdomain : subdomains.first
    when Provider, Seeker
      resource.place.region.subdomain
    end
  rescue
    'www'
  end
end
