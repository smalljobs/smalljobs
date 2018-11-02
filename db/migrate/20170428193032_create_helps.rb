class CreateHelps < ActiveRecord::Migration
  def change
    create_table :helps do |t|
      t.string :title
      t.text :description
      t.string :url

      t.timestamps
    end
  end
end
