class CreateEditorFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :editor_files do |t|
      t.string :file
      t.timestamps
    end
  end
end
