class AddSalaryDeductionToRganization < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :salary_deduction, :float, default: 0
  end
end
