class AddExpirationToAccessTokens < ActiveRecord::Migration
  def change
    add_column :access_tokens, :expire_at, :datetime
  end
end
