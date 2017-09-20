class CreateAccessTokens < ActiveRecord::Migration
  def change
    create_table :access_tokens do |t|
      t.string :access_token
      t.string :token_type
      t.string :refresh_token
      t.references :seeker
      t.timestamps
    end
  end
end
