class CreateNewAllocations < ActiveRecord::Migration
  def change
    create_table :allocations do |t|
      t.references :job
      t.references :seeker

      t.integer :state
      t.string :feedback_seeker
      t.string :feedback_provider
      t.boolean :contract_returned
      t.timestamps
    end
  end
end
