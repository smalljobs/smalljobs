class AddSignaturesOnContractToOrganization < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :signature_on_contract, :boolean, default: true
  end
end
