class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.references :region

      t.integer :zip, null: false
      t.string  :name, null: false

      t.string :state
      t.string :province

      t.decimal :longitude, precision: 9, scale: 6, null: false
      t.decimal :latitude, precision: 9, scale: 6, null: false

      t.timestamps
    end

    add_index :places, :zip
    add_index :places, :name
  end
end
