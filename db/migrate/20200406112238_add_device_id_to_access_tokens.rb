class AddDeviceIdToAccessTokens < ActiveRecord::Migration[5.0]
  def change
    add_column :access_tokens, :device_id, :string
  end
end
