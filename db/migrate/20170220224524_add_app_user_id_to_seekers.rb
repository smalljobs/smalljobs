class AddAppUserIdToSeekers < ActiveRecord::Migration
  def change
    add_column :seekers, :app_user_id, :integer
  end
end
