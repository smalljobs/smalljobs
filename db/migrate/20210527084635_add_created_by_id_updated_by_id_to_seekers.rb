class AddCreatedByIdUpdatedByIdToSeekers < ActiveRecord::Migration[5.0]
  def change
    add_column :seekers, :created_by_id, :integer
    add_column :seekers, :updated_by_id, :integer
  end
end
