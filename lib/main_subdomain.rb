class MainSubdomain
  def self.matches?(request)
    request.subdomains.first == 'www'
  end
end
