class AddLastMessageToSeekers < ActiveRecord::Migration[5.0]
  def change
    add_column :seekers, :last_message_date, :datetime
    add_column :seekers, :last_message_sent_from_seeker, :boolean
    add_column :seekers, :last_message_seen, :boolean
  end
end
