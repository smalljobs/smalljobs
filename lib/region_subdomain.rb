class RegionSubdomain
  def self.matches?(request)
    Region.exists?(subdomain: request.subdomains.first)
    # Region.exists?(subdomain: "smalljobs")
  end
end
