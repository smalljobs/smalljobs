class CreateProposals < ActiveRecord::Migration
  def change
    create_table :proposals do |t|
      t.references :job
      t.references :seeker

      t.text :message

      t.timestamps
    end
  end
end
