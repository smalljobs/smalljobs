class ModifyJobsSalary < ActiveRecord::Migration
  def change
    change_column_null :jobs, :salary, true
  end
end
