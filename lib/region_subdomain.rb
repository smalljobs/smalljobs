class RegionSubdomain
  def self.matches?(request)
    # Region.exists?(subdomain: request.subdomain)
    Region.exists?(subdomain: "smalljobs")
  end
end
