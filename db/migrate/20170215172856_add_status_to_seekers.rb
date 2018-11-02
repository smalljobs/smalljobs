class AddStatusToSeekers < ActiveRecord::Migration
  def change
    add_column :seekers, :status, :integer, default: 1
  end
end
