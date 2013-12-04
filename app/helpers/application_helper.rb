module ApplicationHelper

  def job_provider_contact_preferences
    [
      [I18n.t('contacts.postal'), 'postal' ],
      [I18n.t('contacts.phone'), 'phone' ],
      [I18n.t('contacts.email'), 'email' ],
      [I18n.t('contacts.mobile'), 'mobile' ]
    ]
  end

  def job_seeker_contact_preferences
    [
      [I18n.t('contacts.whatsapp'), 'whatsapp' ],
      [I18n.t('contacts.mobile'), 'mobile' ],
      [I18n.t('contacts.email'), 'email' ],
      [I18n.t('contacts.phone'), 'phone' ]
    ]
  end

  def flash_class(level)
    case level
    when :notice then 'alert-info'
    when :error then 'alert-error'
    when :alert then 'alert-warning'
    end
  end

end
