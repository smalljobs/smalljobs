class AddSexToSeekers < ActiveRecord::Migration
  def change
    add_column :seekers, :sex, :string
  end
end
