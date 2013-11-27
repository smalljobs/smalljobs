RailsAdmin.config do |config|
  config.main_app_name = ['Small Jobs', 'Admin']
  config.current_user_method { current_admin }
end
