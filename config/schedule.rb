# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every 1.day, at: '4am' do # Use any day of the week or :weekend, :weekday
  rake "smalljobs:send_weekly_update"
end

every 1.day, at: '3am' do # Use any day of the week or :weekend, :weekday
  rake "smalljobs:end_vacation"
end

every 1.day, at: '10am' do # Use any day of the week or :weekend, :weekday
  rake "smalljobs:send_reminder_to_new_user"
end

every 1.day, at: '1am' do
  rake "smalljobs:update_broker_from_rc"
end

every 1.day, at: '1am' do
  rake "smalljobs:update_postoponed_todos"
end

# every :monday, at: '12pm' do # Use any day of the week or :weekend, :weekday
#   rake "smalljobs:send_job_reminder"
# end
