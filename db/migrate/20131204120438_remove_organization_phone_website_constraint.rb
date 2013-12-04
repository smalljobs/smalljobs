class RemoveOrganizationPhoneWebsiteConstraint < ActiveRecord::Migration
  def change
    change_column_null :organizations, :phone, true
    change_column_null :organizations, :website, true
  end
end
