RailsAdmin.config do |config|
  config.main_app_name = ['Small Jobs', 'Adminstration']

  config.authenticate_with do
    authenticate_admin!
  end

  config.current_user_method { current_admin }

  config.model Admin do
    navigation_label I18n.t('admin.menu.user')
  end

  config.model JobBroker do
    navigation_label I18n.t('admin.menu.user')
  end

  config.model JobProvider do
    navigation_label I18n.t('admin.menu.user')
  end

  config.model JobSeeker do
    navigation_label I18n.t('admin.menu.user')
  end

  config.model WorkCategory do
    navigation_label I18n.t('admin.menu.job')
  end

  config.model Region do
    navigation_label I18n.t('admin.menu.geo')
  end

  config.model Place do
    navigation_label I18n.t('admin.menu.geo')
  end
end
