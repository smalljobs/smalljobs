class AddHideSalaryToOrganization < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :hide_salary, :boolean, default: false
  end
end
