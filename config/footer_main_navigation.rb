SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = SimpleNavigationRenderers::Bootstrap3
  navigation.items do |primary|
    primary.item :privacy_policy,   I18n.t('navigation.privacy_policy'),   privacy_policy_path
    primary.item :terms_of_service, I18n.t('navigation.terms_of_service'), terms_of_service_path
    primary.dom_class = 'navbar-right'
  end
end
