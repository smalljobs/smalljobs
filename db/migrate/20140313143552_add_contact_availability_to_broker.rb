class AddContactAvailabilityToBroker < ActiveRecord::Migration
  def change
    add_column :brokers, :contact_availability, :text
  end
end
