namespace :smalljobs do

  desc 'Send a message to new user not activated since 30 days'
  task send_reminder_to_new_user: :environment do
    ::Messages::Seekers.first_reminder_to_inactive
    ::Messages::Seekers.second_reminder_to_inactive
  end

end
