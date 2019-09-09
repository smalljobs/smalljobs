class Above18OrganizationMessages < ActiveRecord::Migration[5.0]
  def up
    add_column :organizations, :welcome_app_register_above_18_msg, :text
    add_column :organizations, :welcome_chat_register_above_18_msg, :text
    add_column :organizations, :welcome_email_for_parents_above_18_msg, :text

    msg_hash = { welcome_app_register_above_18_msg: "Hallo {{{seeker_first_name}}}
Willkommen bei der Jobbörse!",
      welcome_chat_register_above_18_msg: "Hallo {{{seeker_first_name}}}
Willkommen bei der Jobbörse!

(Öffnungszeiten siehe Internet)",
      welcome_email_for_parents_above_18_msg: "Guten Tag
Ihr Kind {{{seeker_first_name}}} {{{seeker_last_name}}} hat sich bei der
Jobbörse von {{{organization_name}}} registriert und dabei diese Mailadresse angegeben.

Für Fragen erreichen Sie uns unter:
{{{organization_phone}}}
{{{organization_email}}}

Beste Grüsse,
Ihre Jobbörse für Jugendliche {{{organization_name}}}"
    }
    msg_hash.each do |key, msg|
      DefaultTemplate.create(
        template_name: key,
        template: msg
      )
    end

    Organization.find_in_batches(batch_size: 100) do |orgs|
      orgs.each do |org|
        org.update_columns(
          welcome_app_register_above_18_msg: msg_hash[:welcome_app_register_above_18_msg],
          welcome_chat_register_above_18_msg: org[:welcome_chat_register_above_18_msg],
          welcome_email_for_parents_above_18_msg: org[:welcome_email_for_parents_above_18_msg]
        )
      end
    end
  end

  def down
    remove_column :organizations, :welcome_app_register_above_18_msg
    remove_column :organizations, :welcome_chat_register_above_18_msg
    remove_column :organizations, :welcome_email_for_parents_above_18_msg

    msg_arr = [
      :welcome_app_register_above_18_msg,
      :welcome_chat_register_above_18_msg,
      :welcome_email_for_parents_above_18_msg
    ]

    DefaultTemplate.where(template_name: msg_arr).destroy_all
  end
end
