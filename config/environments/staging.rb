Smalljobs::Application.configure do
  # Sendgrid Config
  ActionMailer::Base.smtp_settings = {
      address: ENV['SMTP_ADDRESS'],
      port: '587',
      authentication: :plain,
      user_name: ENV['SMTP_USERNAME'],
      password: ENV['SMTP_PASSWORD'],
      domain: ENV['SMTP_ADDRESS'],
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

  config.assets.precompile += %w( rich/base.js )
  config.assets.precompile += %w( rich/editor.css pdf.css )


  # Mailer default link host
  config.action_mailer.default_url_options = {host: 'dev.smalljobs.ch'}
  config.action_controller.default_url_options = {protocol: 'https'}
end
