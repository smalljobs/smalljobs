class AddColumnsToJobProviders < ActiveRecord::Migration
  def change
    add_column :job_providers, :provider, :string
    add_column :job_providers, :uid, :string
    add_column :job_providers, :name, :string
  end
end
