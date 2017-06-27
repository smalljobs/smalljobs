class CreateTodos < ActiveRecord::Migration[5.0]
  def change
    create_table :todos do |t|
      t.integer :record_id
      t.integer :record_type
      t.references :todotype, foreign_key: true
      t.references :seeker, foreign_key: true
      t.references :job, foreign_key: true
      t.references :provider, foreign_key: true
      t.references :allocation, foreign_key: true

      t.timestamps
    end
  end
end
