class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.references :job
      t.references :seeker

      t.text :message

      t.timestamps
    end
  end
end
