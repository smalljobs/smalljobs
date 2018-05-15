class AddWelcomeEmailForParentsToOrganizations < ActiveRecord::Migration[5.0]
  class Organizations < ActiveRecord::Base
  end

  def change
    add_column :organizations, :welcome_email_for_parents_msg, :text

    Organization.all.each do |organization|
      organization.update_attributes!(welcome_email_for_parents_msg: "Guten Tag\n{{seeker_first_name}} {{seeker_last_name}} hat sich bei der Sackgeldjobbörse von {{organization_name}} registriert.\nDamit ihr Kind mitmachen darf, brauchen wir die Elterneinverständnis. Download hier:\n{{seeker_link_to_agreement}}\nBitte Ausdrucken und unterschreiben.\nIhr Kind sollte dann als nächstes bei uns vorbeikommen für ein Erstgespräch.\nFür Terminvereinbarung sind wir zu erreichen unter:\n{{organization_name}}\n{{organization_street}}\n{{organization_zip}} {{organization_place}}\n\nTelefon: {{organization_phone}}\nE-Mail:  {{organization_email}}\n\nNach diesem Erstgespräch kann sich Ihr Kind via Jugendapp für alle Jobs bewerben.\n\nBeste Grüsse,\nIhre Jobbörse von {{organisation_name}}")
    end
  end
end
