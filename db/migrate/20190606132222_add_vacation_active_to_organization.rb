class AddVacationActiveToOrganization < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :vacation_active, :boolean, default: false
  end
end
