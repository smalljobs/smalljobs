class ModifyProviderActiveDefault < ActiveRecord::Migration
  def change
    change_column_default(:providers, :active, true)
  end
end
