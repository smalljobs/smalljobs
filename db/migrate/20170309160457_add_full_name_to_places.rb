class AddFullNameToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :full_name, :string
  end
end
