class CreateJobSeekersWorkCategories < ActiveRecord::Migration
  def change
    create_table :job_seekers_work_categories do |t|
      t.references :job_seeker
      t.references :work_category
    end
  end
end
