class AddWelcomeChatRegisterMsgToOrganizations < ActiveRecord::Migration[5.0]
  class Organizations < ActiveRecord::Base
  end

  def change
    add_column :organizations, :welcome_chat_register_msg, :text

    Organization.all.each do |organization|
      organization.update_attributes!(welcome_chat_register_msg: "Hallo {{seeker_first_name}}\nWillkommen bei unserer Jobbörse! Damit du einverstanden bist, braucht es bis 18 die Einverständnis deiner Eltern.\nFolgendes musst du dafür tun:\n1. Hierr Elterneinverständnis runterladen: {{seeker_link_to_agreement}}\n2. Elterneinverständnis ausdrucken\n3. Elterneinverständnis von Vater oder Mutter unterschreiben lassen.\n4. Bei uns vorbeibringen:  {{organisation_name}}, {{organisation_street}}, {{organisation_zip}} {{organisation_place}}. Wir sind da Mittwoch und Donnerstag 14-18 Uhr. Für einen anderen Termin oder Fragen schreib uns hier im Chat.\nLiebe Grüsse, {{broker_first_name}}, {{organisation_name}}")
    end
  end
end
