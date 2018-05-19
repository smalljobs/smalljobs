class AddLogoToRegions < ActiveRecord::Migration[5.0]
  def change
    add_column :work_categories, :icon_name, :string
  end
end
