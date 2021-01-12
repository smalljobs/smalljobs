class HeaderImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :fog if Rails.env.production? or Rails.env.staging?

  def store_dir
    "uploads/#{ model.class.to_s.underscore }/#{ mounted_as }/#{ model.id }"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  version(:web) do
    version(:normal) { process(resize_to_fit: [2048, 1352]) }
    version(:small) { process(resize_to_fit: [110, 110]) }
  end
end
