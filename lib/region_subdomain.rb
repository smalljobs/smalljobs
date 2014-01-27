class RegionSubdomain
  def self.matches?(request)
    Region.exists?(subdomain: request.subdomain)
  end
end
