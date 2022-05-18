class AddTextFieldToRegionAndUpdateOldOne < ActiveRecord::Migration[5.0]
  def change
    add_column :regions, :provider_contract_rules, :text
    rename_column :regions, :rules, :job_contract_rules
  end
end
