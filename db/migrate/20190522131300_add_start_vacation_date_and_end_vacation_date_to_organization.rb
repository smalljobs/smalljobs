class AddStartVacationDateAndEndVacationDateToOrganization < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :start_vacation_date, :date
    add_column :organizations, :end_vacation_date, :date
  end
end
