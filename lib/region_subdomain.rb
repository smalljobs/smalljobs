class RegionSubdomain
  def self.matches?(request)
    subdomain = request.subdomain
    if subdomain.starts_with? 'www.'
      subdomain.sub! 'www.', ''
    end
    Region.exists?(subdomain: subdomain)
  end
end
