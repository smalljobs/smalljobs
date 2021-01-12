class AddRcIdAndRcUsernameToSeekerAndBroker < ActiveRecord::Migration[5.0]
  def change
    add_column :seekers, :rc_id, :string
    add_column :seekers, :rc_username, :string
    add_column :brokers, :rc_id, :string
    add_column :brokers, :rc_username, :string
  end
end
