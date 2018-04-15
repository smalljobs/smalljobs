class AddNotReceiveJobMsgToOrganizations < ActiveRecord::Migration[5.0]
  class Organizations < ActiveRecord::Base
  end

  def change
    add_column :organizations, :not_receive_job_msg, :text

    Organization.all.each do |organization|
      organization.update_attributes!(not_receive_job_msg: "Hallo {{seeker_first_name}}\nLeider hast du den Job nicht erhalten. Vielleicht klappt es beim nächsten mal.\nLiebe Grüsse, {{broker_first_name}}, {{organization_name}}")
    end
  end
end
