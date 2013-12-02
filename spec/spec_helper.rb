ENV['RAILS_ENV'] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rails'
require 'fabrication'
require 'forgery'
require 'devise'
require 'database_cleaner'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = 'random'

  config.include Devise::TestHelpers, type: :controller
  config.include Support::Authentication::Controller, type: :controller
  config.extend Support::Authentication::Controller::Macros, type: :controller

  config.include Devise::TestHelpers, type: :view
  config.include Support::Authentication::Controller, type: :view
  config.extend Support::Authentication::Controller::Macros, type: :view

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
