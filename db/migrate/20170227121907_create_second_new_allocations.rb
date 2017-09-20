class CreateSecondNewAllocations < ActiveRecord::Migration
  def change
    create_table :allocations do |t|
      t.references :job, index: true
      t.references :seeker, index: true
      t.integer :state
      t.text :feedback_seeker
      t.text :feedback_provider
      t.boolean :contract_returned
      t.datetime :last_change_of_state

      t.timestamps
    end
  end
end
