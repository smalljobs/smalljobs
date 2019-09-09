class ChangeAccessTokenAssociacionToPolimorfic < ActiveRecord::Migration[5.0]
  def up
    # change_table :access_tokens do |t|
    #   t.references :userable, polymorphic: true
    # end
    rename_column :access_tokens, :seeker_id, :userable_id
    add_column :access_tokens, :userable_type, :string, default: "Seeker"
  end

  def down
    # change_table :access_tokens do |t|
    #   t.remove_references :userable, polymorphic: true
    # end
    rename_column :access_tokens, :userable_id, :seeker_id
    remove_column :access_tokens, :userable_type
  end
end
