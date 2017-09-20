class AddContractToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :contract, :boolean, default: true
  end
end
