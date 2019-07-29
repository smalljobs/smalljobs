class AddAgeRangeToOrganization < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :from_age, :integer, default: 13
    add_column :organizations, :to_age, :integer, default: 26
  end
end
