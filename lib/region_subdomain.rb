class RegionSubdomain
  def self.matches?(request)
    subdomain = request.subdomains[0]
    if subdomain == 'www'
      subdomain = request.subdomains[1]
    end
    Region.exists?(subdomain: subdomain)
  end
end
