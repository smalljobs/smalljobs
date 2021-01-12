class EditorFileUploader < CarrierWave::Uploader::Base
  # storage :fog if Rails.env.production? or Rails.env.staging?

  def store_dir
    "uploads/#{ model.class.to_s.underscore }/#{ mounted_as }/#{ model.id }"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  version(:web) do
    version(:normal)
  end
end
