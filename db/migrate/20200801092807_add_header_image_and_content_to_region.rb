class AddHeaderImageAndContentToRegion < ActiveRecord::Migration[5.0]
  def change
    add_column :regions, :header_image, :string
    add_column :regions, :content, :text
  end
end
