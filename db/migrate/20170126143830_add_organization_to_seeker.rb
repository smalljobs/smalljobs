class AddOrganizationToSeeker < ActiveRecord::Migration
  def change
    add_reference :seekers, :organization, index: true
  end
end
