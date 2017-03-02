class RemoveLoginFromProviders < ActiveRecord::Migration
  def change
    remove_column :providers, :login
  end
end
