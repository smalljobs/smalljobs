namespace :smalljobs do

  desc 'Send weekly update to brokers'
  task send_weekly_update: :environment do
    Job.send_rating_reminders
  end

end
