class CreateNotes < ActiveRecord::Migration[5.0]
  def change
    add_column :regions, :logo, :string
  end
end
