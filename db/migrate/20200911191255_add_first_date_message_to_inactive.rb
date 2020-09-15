class AddFirstDateMessageToInactive < ActiveRecord::Migration[5.0]
  def change
    add_column :seekers, :first_date_message_to_inactive, :date
  end
end
