class RemoveDescriptionFromJobs < ActiveRecord::Migration
  def change
    remove_column :jobs, :description
  end
end
