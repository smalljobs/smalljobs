SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = SimpleNavigationRenderers::Bootstrap2

  navigation.items do |primary|
    primary.item :about_us, I18n.t('navigation.about_us'), about_us_path
    primary.item :features, I18n.t('navigation.features'), features_path
    primary.item :join_us,  I18n.t('navigation.join_us'),  join_us_path

    primary.dom_class = 'nav-pills pull-right'
  end
end
