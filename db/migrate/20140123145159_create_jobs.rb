class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.references :provider, null: false
      t.references :work_category, null: false

      t.string :title, null: false
      t.text :description, null: false

      t.string :date_type, null: false
      t.datetime :start_date
      t.datetime :end_date

      t.decimal :salary, precision: 8, scale: 2, null: false
      t.string  :salary_type, default: 'hourly', null: false

      t.integer :manpower, default: 1, null: false
      t.integer :duration, null: false

      t.timestamps
    end

    create_table :jobs_seekers do |t|
      t.references :job
      t.references :seeker
    end

    add_index :jobs, :title
  end
end
