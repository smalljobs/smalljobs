class RemoveJobSeekers < ActiveRecord::Migration
  def change
    drop_table :jobs_seekers
  end
end
