class AddAbsenceToOrganization < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :vacation_title, :string
    add_column :organizations, :vacation_text, :text
  end
end
