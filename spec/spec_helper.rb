ENV['RAILS_ENV'] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rails'
require 'capybara/email'
require 'fabrication'
require 'forgery'
require 'devise'
require 'database_cleaner'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

Capybara.always_include_port = true

Capybara.register_driver :firefox_with_firebug do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile.add_extension(File.expand_path(File.join(Rails.root, 'spec', 'support', 'xpi', 'firebug-1.12.5.xpi')))

  # Configures Firebug - look at http://getfirebug.com/wiki/index.php/Firebug_Preferences
  profile['extensions.firebug.currentVersion']      = '1.12.5'
  profile['extensions.firebug.previousPlacement']   = 3
  profile['extensions.firebug.allPagesActivation']  = 'on'
  profile['extensions.firebug.console.enableSites'] = true
  profile['extensions.firebug.net.enableSites']     = true
  profile['extensions.firebug.script.enableSites']  = true
  profile['extensions.firebug.showStackTrace']      = true
  profile['extensions.firebug.defaultPanelName']    = 'console'
  profile['toolkit.telemetry.prompted']             = '2'
  profile['toolkit.telemetry.rejected']             = 'true'

  client = Selenium::WebDriver::Remote::Http::Default.new
  client.timeout = 300

  Capybara::Selenium::Driver.new(app, browser: :firefox, profile: profile, http_client: client)
end

Capybara.register_driver :firefox do |app|
  profile                                     = Selenium::WebDriver::Firefox::Profile.new
  profile.secure_ssl                          = false
  profile.assume_untrusted_certificate_issuer = false

  client = Selenium::WebDriver::Remote::Http::Default.new
  client.timeout = 300

  Capybara::Selenium::Driver.new(app, browser: :firefox, profile: profile, http_client: client)
end

Capybara.register_driver :chrome do |app|
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.timeout = 300

  Capybara::Selenium::Driver.new(app, browser: :chrome, http_client: client)
end

Capybara.register_driver :phantomjs do |app|
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.timeout = 120
  Capybara::Selenium::Driver.new(app, browser: :phantomjs, http_client: client)
end

Capybara.configure do |config|
  config.default_selector = :css

  config.ignore_hidden_elements = true
  config.match                  = :prefer_exact

  config.default_driver    = :rack_test
  config.javascript_driver = ENV['JS_DRIVER'] ? ENV['JS_DRIVER'].to_sym : :firefox_with_firebug
  config.default_wait_time = ENV['CI'] ? 15 : 2
end

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.order = 'random'

  config.include Devise::TestHelpers, type: :controller
  config.include Support::Authentication::Controller, type: :controller
  config.extend Support::Authentication::Controller::Macros, type: :controller

  config.include Devise::TestHelpers, type: :view
  config.include Support::Authentication::Controller, type: :view
  config.extend Support::Authentication::Controller::Macros, type: :view

  config.include Support::Feature, type: :feature
  config.include Capybara::Email::DSL, type: :feature

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
