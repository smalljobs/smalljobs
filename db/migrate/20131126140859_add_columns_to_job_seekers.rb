class AddColumnsToJobSeekers < ActiveRecord::Migration
  def change
    add_column :job_seekers, :provider, :string
    add_column :job_seekers, :uid, :string
    add_column :job_seekers, :name, :string
  end
end
