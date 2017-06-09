class ChangeProviderEmailIndex < ActiveRecord::Migration[5.0]
  def change
    remove_index :providers, :email
    add_index :providers, :email, unique: false
  end
end
