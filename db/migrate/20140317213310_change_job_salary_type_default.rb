class ChangeJobSalaryTypeDefault < ActiveRecord::Migration
  def change
    change_column_default :jobs, :salary_type, 'hourly_per_age'
  end
end
