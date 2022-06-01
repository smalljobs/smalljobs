class AddTextFieldsToRegion < ActiveRecord::Migration[5.0]
  def change
    add_column :regions, :rules, :text
    add_column :regions, :detail_link, :string
  end
end
