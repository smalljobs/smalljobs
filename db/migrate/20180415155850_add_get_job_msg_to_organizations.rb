class AddGetJobMsgToOrganizations < ActiveRecord::Migration[5.0]
  class Organizations < ActiveRecord::Base
  end

  def change
    add_column :organizations, :get_job_msg, :text

    Organization.all.each do |organization|
      organization.update_attributes!(get_job_msg: "Hallo {{seeker_first_name}}\nGratuliere! Du hast den Job! Kontaktiere deinen neuen Arbeitgebenden {{job_provider_first_name}} {{job_provider_last_name}} hier:\nMobile: {{job_provider_phone}}\nFür Fragen schreib uns hier im Chat.\nLiebe Grüsse, {{broker_first_name}}, {{organization_name}}")
    end
  end
end
