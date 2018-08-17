class AddActivationMsgToOrganizations < ActiveRecord::Migration[5.0]
  class Organizations < ActiveRecord::Base
  end

  def change
    add_column :organizations, :activation_msg, :text

    Organization.all.each do |organization|
      organization.update_attributes!(activation_msg: "Hallo {{seeker_first_name}}\nGratuliere! Du bist freigeschaltet und kannst dich ab sofort auf Jobs bewerben. Hier offene Jobs anschauen: {{link_to_jobboard_list}}\nLiebe Grüsse, {{broker_first_name}}, {{organization_name}}")
    end
  end
end
