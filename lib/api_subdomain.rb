class ApiSubdomain
  def self.matches?(request)
    request.subdomains.first == 'api'
  end
end
