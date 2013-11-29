SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = SimpleNavigationRenderers::Bootstrap3
  navigation.items do |primary|
    primary.item :home, { icon: 'fa fa-home fa-lg', text: I18n.t('navigation.home') }, root_path
    primary.dom_class = 'nav-pills pull-right'
  end
end
