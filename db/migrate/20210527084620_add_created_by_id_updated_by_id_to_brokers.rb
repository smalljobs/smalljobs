class AddCreatedByIdUpdatedByIdToBrokers < ActiveRecord::Migration[5.0]
  def change
    add_column :brokers, :created_by_id, :integer
    add_column :brokers, :updated_by_id, :integer
  end
end
