# encoding: utf-8

class SportImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "images"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    # For Rails 3.1+ asset pipeline compatibility:
    # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))

    ActionController::Base.helpers.image_path("placeholder.png")
  end

  process :resize_to_fit => [200, 200]

  version :thumb do
    process :resize_to_fill => [80, 80]
  end
end
