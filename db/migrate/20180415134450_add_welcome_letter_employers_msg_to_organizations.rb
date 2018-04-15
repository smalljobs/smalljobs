class AddWelcomeLetterEmployersMsgToOrganizations < ActiveRecord::Migration[5.0]
  class Organizations < ActiveRecord::Base
  end

  def change
    add_column :organizations, :welcome_letter_employers_msg, :text

    Organization.all.each do |organization|
      organization.update_attributes!(welcome_letter_employers_msg: "Guten Tag {{provider_first_name}} {{provider_last_name}}\nWillkommen bei Smalljobs.")
    end
  end
end
