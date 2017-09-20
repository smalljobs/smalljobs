class MainSubdomain
  def self.matches?(request)
    request.subdomain == 'www'
  end
end
