# frozen_string_literal: true

require 'down'

class ImageUploader < Shrine
  plugin :store_dimensions
  plugin :keep_files
  plugin :data_uri
  plugin :infer_extension
  plugin :remote_url,
         max_size: 30.megabytes,
         log_subscriber: lambda { |event|
           Shrine.logger.info JSON.generate(name: event.name, duration: event.duration, **event.payload)
         },
         # NOTE: fixes 308 redirect
         downloader: lambda { |url, **options|
           Down.open(url, **options)
         }

  plugin :determine_mime_type

  # plugin :refresh_metadata
  # plugin :atomic_helpers

  plugin :validation_helpers

  Attacher.validate do
    validate_max_size 30.megabytes
    #  video/mp4 video/webm application/mp4 video/mp4 video/quicktime video/avi video/mpeg video/x-mpeg video/x-msvideo video/m4v video/x-m4v video/vnd.objectvideo
    validate_mime_type %w[image/jpeg image/jpg image/png image/gif image/webp image/vnd.microsoft.icon image/svg+xml]
  end

  derivation :thumbnail do |file, width, height|
    next source.download if source.mime_type == 'image/svg+xml'

    # R: reliability, :) I mast take a look later in places like Mastodon, Exercism, Discourse...
    ImageProcessing::MiniMagick
      .source(file)
      .coalesce
      .resize_to_limit(width.to_i, height.to_i)
      .call
  rescue StandardError => e
    ImageProcessing::Vips
      .source(file)
      .resize_to_limit(width.to_i, height.to_i)
      .convert('webp')
      .call
  end

  plugin :derivation_endpoint,
         metadata: %w[filename mime_type],
         upload: true,
         prefix: 'derivations/image', # matches mount point
         type: -> { source['mime_type'] }
         # disposition: -> { name == :thumbnail ? "inline" : "attachment" },
         # filename:    -> { [name, *args].join("-") }

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
