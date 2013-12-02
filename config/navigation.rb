SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = SimpleNavigationRenderers::Bootstrap2

  navigation.items do |primary|
    if job_broker_signed_in?
      primary.item :home, { icon: 'fa fa-dashboard', text: I18n.t('navigation.dashboard') }, job_brokers_dashboard_path
      primary.item :home, { icon: 'fa fa-sign-out', text: I18n.t('navigation.sign_out') }, destroy_job_broker_session_path

    elsif job_provider_signed_in?
      primary.item :home, { icon: 'fa fa-dashboard', text: I18n.t('navigation.dashboard') }, job_providers_dashboard_path
      primary.item :home, { icon: 'fa fa-sign-out', text: I18n.t('navigation.sign_out') }, destroy_job_provider_session_path

    elsif job_seeker_signed_in?
      primary.item :home, { icon: 'fa fa-dashboard', text: I18n.t('navigation.dashboard') }, job_seekers_dashboard_path
      primary.item :home, { icon: 'fa fa-sign-out', text: I18n.t('navigation.sign_out') }, destroy_job_seeker_session_path

    else
      primary.item :home, { icon: 'fa fa-user', text: I18n.t('navigation.sign_up') }, root_path
      primary.item :home, { icon: 'fa fa-sign-in', text: I18n.t('navigation.sign_in') }, sign_in_path
    end

    primary.dom_class = 'nav-pills pull-right'
  end
end
