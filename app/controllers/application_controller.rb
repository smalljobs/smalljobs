require 'app_responder'

class ApplicationController < ActionController::Base
  before_filter :require_https
  before_filter :redirect_www
  before_filter :redirect_if_region_empty

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
        redirect_to('/sign_in', alert: exception.message)
      when /^\/broker/
        redirect_to('/sign_in', alert: exception.message)
      when /^\/provider/
        redirect_to('/sign_in', alert: exception.message)
      when /^\/seeker/
        redirect_to('/sign_in', alert: exception.message)
      else
        redirect_to(root_url, alert: exception.message)
      end
    end
  end

  helper_method :current_region

  protected

  def require_https
    redirect_to protocol: 'https://' unless request.ssl? || request.local? || request.subdomain == 'dev' || Rails.env.test?
  end

  def redirect_www
    if request.subdomains[0] == 'www'
      redirect_to request.url.sub('//www.', '//')
    end
  end

  def redirect_smalljobs
    if request.subdomain == 'smalljobs'
      redirect_to "https://winterthur.smalljobs.ch#{request.fullpath}", :status => :moved_permanently
    end
  end

  def redirect_if_region_empty
    if request.subdomain != 'api' and Region.where(subdomain: request.subdomain).blank?
      redirect_to "https://smalljobs.ch/lokal"
    end
  end

  def current_user
    role = respond_to?(:resource_name) ? resource_name : nil

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

  def current_ability
    @current_ability ||= Ability.new(current_user, current_region)
  end

  def current_region
    @region ||= Region.find_by_subdomain(request.subdomains.first)
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
      rails_admin.dashboard_url(subdomain: request.subdomains.first)
    else
      super
    end
  end

  private

  def ensure_subdomain_for(resource)
    case resource
      when Broker
        return request.subdomain
      subdomains = resource.regions.pluck(:subdomain)
      subdomains.include?(request.subdomains.first) ? request.subdomains.first : subdomains.first
    when Provider, Seeker
      resource.place.region.subdomain
    end
  rescue
    'www'
  end
end
