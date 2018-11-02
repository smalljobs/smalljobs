class AddConversationIdToAllocations < ActiveRecord::Migration
  def change
    add_column :allocations, :conversation_id, :integer
  end
end
