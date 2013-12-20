class RenameUserTables < ActiveRecord::Migration
  def change
    rename_table(:job_providers, :providers)
    rename_table(:job_brokers, :brokers)
    rename_table(:job_seekers, :seekers)
    rename_table(:job_seekers_work_categories, :seekers_work_categories)

    rename_column(:seekers_work_categories, :job_seeker_id, :seeker_id)
    rename_column(:employments, :job_broker_id, :broker_id)
  end
end
