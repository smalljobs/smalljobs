class AddDefaultHourlyPerAgeSalaryToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :default_hourly_per_age, :decimal, precision: 8, scale: 2, default: 1.00
  end
end
