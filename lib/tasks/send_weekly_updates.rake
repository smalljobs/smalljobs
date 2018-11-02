namespace :smalljobs do

  desc 'Send weekly update to brokers'
  task send_weekly_update: :environment do
    Broker.send_weekly_update
  end

end
