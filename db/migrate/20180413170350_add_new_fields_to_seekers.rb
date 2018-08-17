class AddNewFieldsToSeekers < ActiveRecord::Migration[5.0]
  def change
    add_column :seekers, :occupation, :string
    add_column :seekers, :occupation_end_date, :date
    add_column :seekers, :additional_contacts, :text
    add_column :seekers, :languages, :string
  end
end
