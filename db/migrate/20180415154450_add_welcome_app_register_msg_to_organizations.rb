class AddWelcomeAppRegisterMsgToOrganizations < ActiveRecord::Migration[5.0]
  class Organizations < ActiveRecord::Base
  end

  def change
    add_column :organizations, :welcome_app_register_msg, :text

    Organization.all.each do |organization|
      organization.update_attributes!(welcome_app_register_msg: "Persönlich bei:\n{{organization_name}}\n{{organization_street}}\n{{organization_zip}} {{organization_place}}\nOffen Mi und Do von 14-18 Uhr oder nach Vereinbarung")
    end
  end
end
