class LogoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :fog if Rails.env.production?

  def store_dir
    "uploads/#{ model.class.to_s.underscore }/#{ mounted_as }/#{ model.id }"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  version(:web) do
    version(:normal) { process(resize_to_fit: [400, 220]) }
    version(:small) { process(resize_to_fit: [110, 110]) }
  end
end
