class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :status
      t.references :seeker
      t.references :provider
      t.datetime :start_time
      t.datetime :end_time
      t.text :feedback
      t.timestamps
    end
  end
end
