module ApplicationHelper


  # Get the translated select options for
  # the provider contact preferences.
  #
  # @return [Array<String, String>] the preferences
  #
  def provider_contact_preferences
    [
      [I18n.t('contacts.postal'), 'postal' ],
      [I18n.t('contacts.phone'), 'phone' ],
      [I18n.t('contacts.email'), 'email' ],
      [I18n.t('contacts.mobile'), 'mobile' ]
    ]
  end

  # Get the translated select options for
  # the seeker contact preferences.
  #
  # @return [Array<String, String>] the preferences
  #
  def seeker_contact_preferences
    [
      [I18n.t('contacts.whatsapp'), 'whatsapp' ],
      [I18n.t('contacts.mobile'), 'mobile' ],
      [I18n.t('contacts.email'), 'email' ],
      [I18n.t('contacts.phone'), 'phone' ]
    ]
  end

  # Maps the flash message to a bootstrap alert
  #
  # @param [Symbol] kind the flash type
  # @return [String] the bootstrap class
  #
  def flash_class(kind)
    case kind
    when :notice then 'alert-info'
    when :error then 'alert-error'
    when :alert then 'alert-warning'
    end
  end

  # Get the table bootstrap class depending
  # on the provider status
  #
  # @param [Provider] the provider
  # @return [String] the bootstrap class
  #
  def provider_status_class(provider)
    if !provider.confirmed?
      'warning'
    elsif !provider.active?
      'danger'
    else
      ''
    end
  end

  # Get the table label depending
  # on the provider status
  #
  # @param [Provider] the provider
  # @return [Array<String>] the label type and text
  #
  def provider_label(provider)
    if !provider.confirmed?
      bootstrap_label('warning', I18n.t('common.unconfirmed'))
    elsif !provider.active?
      bootstrap_label('danger', I18n.t('common.inactive'))
    else
      bootstrap_label('success', I18n.t('common.active'))
    end
  end

  # Creates a bootstrap label
  #
  # @param [Array<String>] label the label type and text
  # @return [String] the label span
  #
  def bootstrap_label(type, text)
    content_tag(:span, text, class: "label label-#{ type }")
  end

end
