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
      :provider               => 'AWS',
      :aws_access_key_id      => 'AKIAJEVCB52WKZEBX5MA',
      :aws_secret_access_key  => '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',
      :region                 => 'eu-west-1'
    }

    config.fog_directory  = "#{ Rails.env }.smalljobs.ch"
    config.fog_public     = false
  end
end
