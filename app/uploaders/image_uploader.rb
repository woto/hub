# frozen_string_literal: true

require 'down'

class ImageUploader < Shrine
  IMAGE_TYPES = %w[image/jpeg image/jpg image/png image/gif image/webp image/vnd.microsoft.icon image/svg+xml].freeze
  VIDEO_TYPES = %w[video/mp4 video/webm application/mp4 video/mp4 video/quicktime video/avi video/mpeg video/x-mpeg
                   video/x-msvideo video/m4v video/x-m4v video/vnd.objectvideo].freeze
  # PDF_TYPES   = %w[application/pdf]

  plugin :store_dimensions
  plugin :keep_files
  plugin :data_uri
  plugin :infer_extension
  plugin :remote_url,
         max_size: 30.megabytes,
         log_subscriber: lambda { |event|
           Shrine.logger.info JSON.generate(name: event.name, duration: event.duration, **event.payload)
         },
         downloader: lambda { |url, **options|
           # TODO: fix 308 redirect
           Down.download(url, **options)
         }

  add_metadata do |io|
    movie = Shrine.with_file(io) do |file|
      FFMPEG::Movie.new(file.path)
    end

    { "duration"   => movie.duration,
      "bitrate"    => movie.bitrate,
      "resolution" => movie.resolution,
      "frame_rate" => movie.frame_rate }
  end

  plugin :determine_mime_type

  # plugin :refresh_metadata
  # plugin :atomic_helpers

  plugin :validation_helpers

  Attacher.validate do
    validate_max_size 30.megabytes
    validate_mime_type IMAGE_TYPES + VIDEO_TYPES
  end

  derivation :image do |file, width, height|
    # debugger

    next source.download if source.mime_type == 'image/svg+xml'

    # R: reliability, :) I mast take a look later in places like Mastodon, Exercism, Discourse...
    # https://github.com/mastodon/mastodon/blob/main/app/models/concerns/attachmentable.rb
    # https://github.com/mastodon/mastodon/blob/main/app/models/media_attachment.rb

    if IMAGE_TYPES.include? source.mime_type

      if ['image/gif', 'image/vnd.microsoft.icon', 'image/x-icon'].include? source.mime_type
        begin
          result = ImageProcessing::MiniMagick
                  .source(file)
                  .coalesce
                  .resize_to_limit(width.to_i, height.to_i)
                  .call

          next result
        rescue StandardError => e
        end
      end

      begin
        result = ImageProcessing::Vips
                 .source(file)
                 .resize_to_limit(width.to_i, height.to_i)
                 .convert('webp')
                 .call

        next result
      rescue StandardError => e
      end
    end

    if VIDEO_TYPES.include? source.mime_type
      begin
        # debugger
        tempfile = Tempfile.new %w[image .jpg]
        movie = FFMPEG::Movie.new(file.path)
        image = movie.screenshot(tempfile.path, { resolution: "#{width}x#{height}" }, { preserve_aspect_ratio: :width })
        result = File.open(image.path)

        next result
      rescue StandardError => e
      end
    end
  end

  derivation :video do |file, width, height|
    # debugger

    if VIDEO_TYPES.include? source.mime_type
      begin
        tempfile = Tempfile.new %w[video .mp4]
        movie = FFMPEG::Movie.new(file.path)
        video = movie.transcode(tempfile.path, { resolution: "#{width}x#{height}" }, { preserve_aspect_ratio: :width })
        result = File.open(video.path)

        next result
      rescue StandardError => e
      end
    end
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
