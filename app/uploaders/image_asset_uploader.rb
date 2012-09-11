# encoding: utf-8

class ImageAssetUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  process :store_geometry

  def store_geometry
    if model
      model.dimensions = dimensions
    end
  end

  # Returns the dimensions of the image as a hash
  def dimensions
    @dimensions ||= begin
      if @file
        img = ::Magick::Image::read(@file.file).first
        { width: img.columns, height: img.rows }
      end
    end
  end

  def scale(scale)
    width  = dimensions[:width]  * scale
    height = dimensions[:height] * scale

    resize(width, height)
  end

  def resize(width, height)
     manipulate! do |img|
      img.resize_to_fit!(width, height)
      img = yield(img) if block_given?
      img
    end
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :golden do
    process scale: 0.618
  end

  version :thirtysix do
    process scale: 0.36
  end

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fit => [200, 200]
  end

  # Only allow images
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
