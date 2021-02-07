class AddContactContentToRegion < ActiveRecord::Migration[5.0]
  def change
    add_column :regions, :contact_content, :text
  end
end
