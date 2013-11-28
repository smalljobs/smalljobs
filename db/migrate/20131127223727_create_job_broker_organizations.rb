class CreateEmployments < ActiveRecord::Migration
  def change
    create_table :employments do |t|
      t.references :organization
      t.references :job_broker
      t.references :region

      t.timestamps
    end
  end
end
