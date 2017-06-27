class ChangeJobDates < ActiveRecord::Migration
  def change
    change_column :jobs, :start_date, :date
    change_column :jobs, :end_date, :date
  end
end
