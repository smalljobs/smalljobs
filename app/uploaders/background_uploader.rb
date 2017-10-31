class BackgroundUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :fog

  def store_dir
    "uploads/#{ Rails.application.routes.url_helpers.root_url }/#{ model.class.to_s.underscore }/#{ mounted_as }/#{ model.id }"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  version(:web) do
    process(resize_to_fit: [700, 400])
  end
end
