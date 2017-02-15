class AddProviderToAllocations < ActiveRecord::Migration
  def change
    add_reference :allocations, :provider, index: true
  end
end
