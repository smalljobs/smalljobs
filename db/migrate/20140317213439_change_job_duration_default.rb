class ChangeJobDurationDefault < ActiveRecord::Migration
  def change
    change_column_default :jobs, :duration, 1
  end
end
