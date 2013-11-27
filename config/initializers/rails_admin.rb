RailsAdmin.config do |config|
  config.main_app_name = ['Small Jobs', 'Adminstration']

  config.authenticate_with do
    authenticate_admin!
  end

  config.current_user_method { current_admin }

  config.model Admin do
    navigation_label 'Benutzer'
  end

  config.model JobBroker do
    navigation_label 'Benutzer'
  end

  config.model JobProvider do
    navigation_label 'Benutzer'
  end

  config.model JobSeeker do
    navigation_label 'Benutzer'
  end

  config.model WorkCategory do
    navigation_label 'Job'
  end
end
