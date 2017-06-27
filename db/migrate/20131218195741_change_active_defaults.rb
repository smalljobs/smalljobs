class ChangeActiveDefaults < ActiveRecord::Migration
  def change
    change_column_default(:job_providers, :active, false)
    change_column_default(:job_providers, :active, false)
    change_column_default(:job_seekers, :active, false)
  end
end
