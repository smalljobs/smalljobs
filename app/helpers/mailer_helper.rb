module MailerHelper

  def subdomain_for(resource)
    case resource
      when Broker
        unless resource.regions.first.nil?
          return resource.regions.first.subdomain
        end
      when Provider, Seeker
        unless resource.organization.regions.first.nil?
          return resource.organization.regions.first.subdomain
        end
    end

    return 'winterthur'
  end

end
