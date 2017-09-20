class AddWageFactorToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :wage_factor, :float
  end
end
