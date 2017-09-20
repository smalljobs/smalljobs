class AddRecoveryCodeToSeeker < ActiveRecord::Migration[5.0]
  def change
    add_column :seekers, :recovery_code, :string
  end
end
