class RemoveNewAllocations < ActiveRecord::Migration
  def change
    drop_table :allocations
  end
end
