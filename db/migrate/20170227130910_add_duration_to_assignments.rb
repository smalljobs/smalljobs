class AddDurationToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :duration, :integer
  end
end
