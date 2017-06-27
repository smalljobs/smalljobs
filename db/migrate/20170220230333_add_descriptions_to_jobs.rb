class AddDescriptionsToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :long_description, :text
    add_column :jobs, :short_description, :text
  end
end
