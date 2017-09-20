class CreateTodotypes < ActiveRecord::Migration[5.0]
  def change
    create_table :todotypes do |t|
      t.string :title, nil: false
      t.text :description, nil: false
      t.integer :table, nil: false
      t.string :where, nil: false

      t.timestamps
    end
  end
end
