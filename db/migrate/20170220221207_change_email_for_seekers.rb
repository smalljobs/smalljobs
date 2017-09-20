class ChangeEmailForSeekers < ActiveRecord::Migration
  def change
    change_column_null :seekers, :email, true
  end
end
