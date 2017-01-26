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
      case request.path
      when /^\/admin/
        redirect_to('/admins/sign_in', alert: exception.message)
      when /^\/broker/
        redirect_to('/brokers/sign_in', alert: exception.message)
      when /^\/provider/
        redirect_to('/providers/sign_in', alert: exception.message)
      when /^\/seeker/
        redirect_to('/seekers/sign_in', alert: exception.message)
      else
        redirect_to(root_url, alert: exception.message)
      end
    end
  end

  helper_method :current_region

  protected

  def current_user
    role = self.respond_to?(:resource_name) ? self.resource_name : nil

    case role
    when :broker
      current_broker
    when :provider
      current_provider
    when :seeker
      current_seeker
    else
      current_admin
    end
  end

  def current_region
    # @region ||= Region.find_by_subdomain(request.subdomain)
    @region ||= Region.find_by_subdomain("smalljobs")
  end

  def after_sign_in_path_for(resource)
    case resource
    when Broker
      broker_dashboard_url(subdomain: ensure_subdomain_for(resource))
    when Provider
      provider_dashboard_url(subdomain: ensure_subdomain_for(resource))
    when Seeker
      seeker_dashboard_url(subdomain: ensure_subdomain_for(resource))
    when Admin
      rails_admin.dashboard_url(subdomain: request.subdomain)
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
