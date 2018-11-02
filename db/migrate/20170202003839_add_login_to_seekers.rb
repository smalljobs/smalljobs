class AddLoginToSeekers < ActiveRecord::Migration
  def change
    add_column :seekers, :login, :string, default: "", null: false
  end
end
