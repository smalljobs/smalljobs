class AddLastChangeOfStateToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :last_change_of_state, :datetime
  end
end
