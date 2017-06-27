module MailerHelper

  def subdomain_for(resource)
    case resource
    when Broker
      resource.regions.first.subdomain
    when Provider, Seeker
      resource.place.region.subdomain
    end
  end

end
