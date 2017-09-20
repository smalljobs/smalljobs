class CreateWorkCategories < ActiveRecord::Migration
  def change
    create_table :work_categories do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_index :work_categories, :name
  end
end
