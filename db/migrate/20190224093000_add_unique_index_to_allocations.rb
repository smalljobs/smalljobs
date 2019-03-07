class AddUniqueIndexToAllocations < ActiveRecord::Migration[5.0]
  def change
    add_index :allocations, [:job_id, :seeker_id], unique: true
  end
end
