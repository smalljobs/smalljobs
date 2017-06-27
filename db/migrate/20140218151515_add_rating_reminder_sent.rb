class AddRatingReminderSent < ActiveRecord::Migration
  def change
    add_column :jobs, :rating_reminder_sent, :boolean, default: false
  end
end
