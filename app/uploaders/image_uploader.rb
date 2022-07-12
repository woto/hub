# frozen_string_literal: true

class ImageUploader < Shrine
  plugin :store_dimensions
  plugin :keep_files
  plugin :data_uri
  plugin :infer_extension
  plugin :remote_url, max_size: 30.megabytes

  # plugin :refresh_metadata
  # plugin :atomic_helpers

  plugin :validation_helpers

  Attacher.validate do
    validate_max_size 30.megabytes
    validate_mime_type %w[image/jpeg image/jpg image/png image/gif image/webp image/vnd.microsoft.icon image/svg+xml]
  end

  plugin :derivation_endpoint, upload: true, prefix: 'derivations/image' # matches mount point

  # R: reliability, :) I mast take a look later in places like Mastodon, Discourse...
  derivation :thumbnail do |file, width, height|
    ImageProcessing::MiniMagick
      .source(file)
      .coalesce
      .resize_to_limit(width.to_i, height.to_i)
      .call
  rescue StandardError
    ImageProcessing::Vips
      .source(file)
      .resize_to_limit(width.to_i, height.to_i)
      .convert('webp')
      .call
  end

  def generate_location(io, record: nil, derivative: nil, **)
    return super unless record

    table  = record.class.table_name
    id     = record.id
    prefix = derivative || 'original'

    "uploads/#{table}/#{id}/#{prefix}-#{super}"
  end

  # plugin :default_url
  #
  # Attacher.default_url do |derivative: nil, **|
  #   'https://image.shutterstock.com/image-vector/block-icon-unavailable-600w-1336706924.jpg' if derivative
  # end
end
