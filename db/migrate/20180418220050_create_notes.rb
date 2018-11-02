class CreateNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :notes do |t|
      t.text :message
      t.references :broker
      t.references :seeker
      t.references :provider
      t.references :job
      t.timestamps
    end
  end
end
