class AddMessagesCountToSeekers < ActiveRecord::Migration[5.0]
  def change
    add_column :seekers, :messages_count, :integer
  end
end
