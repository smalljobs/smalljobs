class AddContractIdToAllocations < ActiveRecord::Migration[5.0]
  def up
    add_column :allocations, :contract_id, :uuid
    Allocation.find_in_batches(batch_size: 500) do |allocations|
      allocations.each do |allocation|
        allocation.update_column(:contract_id, SecureRandom.uuid)
      end
    end
  end

  def down
    remove_column :allocations, :contract_id
  end
end
