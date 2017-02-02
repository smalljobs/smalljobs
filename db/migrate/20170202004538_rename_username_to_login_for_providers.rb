class RenameUsernameToLoginForProviders < ActiveRecord::Migration
  def change
    rename_column :providers, :username, :login
  end
end
