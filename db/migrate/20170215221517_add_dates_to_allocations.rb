class AddDatesToAllocations < ActiveRecord::Migration
  def change
    add_column :allocations, :start_datetime, :datetime
    add_column :allocations, :stop_datetime, :datetime
  end
end
