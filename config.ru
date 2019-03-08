# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
use Rack::Static, urls: ['/carrierwave'], root: 'tmp'
run Rails.application

require 'rack/cors'
use Rack::Cors do

  # allow all origins in development
  allow do
    origins '*'
    resource '*',
             headers: :any,
             methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end