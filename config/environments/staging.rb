Smalljobs::Application.configure do
  # Sendgrid Config
  ActionMailer::Base.smtp_settings = {
      address: 'smtp.sendgrid.net',
      port: '587',
      authentication: :plain,
      user_name: ENV['SENDGRID_USERNAME'],
      password: ENV['SENDGRID_PASSWORD'],
      domain: 'heroku.com',
      enable_starttls_auto: true
  }

  config.paperclip_defaults = {
      :storage => :s3,
      :s3_region => ENV['AWS_REGION'],
      :s3_host_name => "s3.#{ENV['AWS_REGION']}.amazonaws.com",
      :s3_credentials => {
          :bucket => ENV['S3_BUCKET_NAME'],
          :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
          :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
      }
  }

  # Mailer default link host
  config.action_mailer.default_url_options = {host: 'dev.smalljobs.ch'}
  config.action_controller.default_url_options = {protocol: 'https'}
end