module MailerHelper

  def subdomain_for(resource)
    case resource
    when Broker
      resource.regions.first.subdomain
    when Provider, Seeker
      resource.organization.regions.first.subdomain
    end
  end

end
