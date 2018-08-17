class AddOpeningHoursToOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :opening_hours, :text
  end
end
