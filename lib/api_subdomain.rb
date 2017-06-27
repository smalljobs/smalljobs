class ApiSubdomain
  def self.matches?(request)
    request.subdomain == 'api'
  end
end
