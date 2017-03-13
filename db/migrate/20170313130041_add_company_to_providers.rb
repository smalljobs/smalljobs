class AddCompanyToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :company, :string
  end
end
