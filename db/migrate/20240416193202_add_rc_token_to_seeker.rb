class AddRcTokenToSeeker < ActiveRecord::Migration[5.0]
  def change
    add_column :seekers, :rc_token, :string
  end
end
