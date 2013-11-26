if ENV['RAILS_ENV'] == 'development'
  timeout 600
  worker_processes 1
else
  preload_app true
  timeout 20
  worker_processes 4

  before_fork do |server, worker|
    ActiveRecord::Base.connection.disconnect!
  end

  after_fork do |server, worker|
    ActiveRecord::Base.establish_connection
  end
end
