class AddParentEmail < ActiveRecord::Migration[5.0]
  def up
    add_column :seekers, :parent_email, :string
    Seeker.find_each do |seeker|
      seeker.update_column(:parent_email, seeker.email)
    end
  end

  def down
    remove_column :seekers, :parent_email, :string
  end
end
