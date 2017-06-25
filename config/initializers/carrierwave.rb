if Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
else
  CarrierWave.configure do |config|
    config.root      = Rails.root.join('tmp')
    config.cache_dir = 'carrierwave'

    config.fog_credentials = {
      provider:               'AWS',
      aws_access_key_id:      ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key:  ENV['AWS_SECRET_ACCESS_KEY'],
      region:                 ENV['AWS_REGION'],
      path_style:             true
    }

    config.fog_directory  = "#{ Rails.env }.smalljobs.ch"
    config.fog_public     = false
  end
end
