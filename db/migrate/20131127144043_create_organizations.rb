class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :logo
      t.string :background

      t.string  :name, null: false
      t.string  :website, null: false

      t.text    :description

      t.string :street, null: false
      t.string :zip, null: false
      t.string :city, null: false

      t.string :email, null: false
      t.string :phone, null: false

      t.boolean :active, default: true

      t.timestamps
    end

    add_index :organizations, :name, unique: true
  end
end
