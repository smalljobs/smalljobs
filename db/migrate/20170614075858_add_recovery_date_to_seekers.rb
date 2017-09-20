class AddRecoveryDateToSeekers < ActiveRecord::Migration[5.0]
  def change
    add_column :seekers, :last_recovery, :date
    add_column :seekers, :recovery_times, :integer
  end
end
