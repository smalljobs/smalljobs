namespace :smalljobs do

  desc 'Send a job rating reminder email'
  task send_job_reminder: :environment do
    Job.send_rating_reminders
  end

end
