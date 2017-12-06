class SmalljobsSubdomain
  def self.matches?(request)
    request.subdomain == 'smalljobs'
  end
end
