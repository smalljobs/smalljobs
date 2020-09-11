class AddReminderMessagesToOrganizations < ActiveRecord::Migration[5.0]
  def up
    add_column :organizations, :first_reminder_message, :text
    add_column :organizations, :second_reminder_message, :text
    [:first_reminder_message, :second_reminder_message].each do |template|
      if DefaultTemplate.where(template_name: template).blank?
        DefaultTemplate.create(template_name: template, template: I18n.t("messages.organizations.#{template}"))
      end
    end
    Organization.all.each do |organization|
      organization.update(first_reminder_message: I18n.t("messages.organizations.first_reminder_message"),
                          second_reminder_message: I18n.t("messages.organizations.second_reminder_message"))
    end
  end

  def down
    remove_column :organizations, :first_reminder_message
    remove_column :organizations, :second_reminder_message
  end
end
