class AddJobState < ActiveRecord::Migration
  def change
    add_column :jobs, :state, :string, default: 'created'
  end
end
