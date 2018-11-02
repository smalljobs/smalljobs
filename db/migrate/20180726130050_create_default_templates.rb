class CreateDefaultTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :default_templates do |t|
      t.text :template_name
      t.text :template
      t.timestamps
    end
  end
end
