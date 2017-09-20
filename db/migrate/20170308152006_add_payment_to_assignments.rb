class AddPaymentToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :payment, :float
  end
end
