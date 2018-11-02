class AddAgreementsToSeekers < ActiveRecord::Migration
  def change
    add_column :seekers, :parental, :boolean
    add_column :seekers, :discussion, :boolean
  end
end
