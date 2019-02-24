class AddUniqueIndexToAllocations < ActiveRecord::Migration[5.0]
  def change
    add_index :allocations, [:job, :seeker], unique: true
  end
end
