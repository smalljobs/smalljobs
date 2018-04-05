class RegionSubdomain
  def self.matches?(request)
    subdomain = request.subdomain
    subdomain.sub! '//www.', '//'
    Region.exists?(subdomain: subdomain)
  end
end
