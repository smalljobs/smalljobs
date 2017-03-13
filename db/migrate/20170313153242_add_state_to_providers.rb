class AddStateToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :state, :integer, default: 2
  end
end
