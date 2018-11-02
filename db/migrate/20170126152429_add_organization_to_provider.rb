class AddOrganizationToProvider < ActiveRecord::Migration
  def change
    add_reference :providers, :organization, index: true
  end
end
