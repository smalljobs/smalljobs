class RemoveEmailIndexFromSeekers < ActiveRecord::Migration
  def change
    remove_index :seekers, :email
  end
end
