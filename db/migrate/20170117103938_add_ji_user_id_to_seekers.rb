class AddJiUserIdToSeekers < ActiveRecord::Migration
  def change
    add_column :seekers, :ji_user_id, :integer
  end
end
