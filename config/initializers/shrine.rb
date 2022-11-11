# frozen_string_literal: true

require 'shrine'
require 'shrine/storage/file_system'

Shrine.plugin :instrumentation
Shrine.logger = Rails.logger

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'), # temporary
  store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads') # permanent
}

Shrine.plugin :add_metadata
Shrine.plugin :activerecord # or :activerecord
Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file
Shrine.plugin :derivatives
Shrine.plugin :derivation_endpoint, secret_key: Rails.application.secret_key_base,
  # host: "#{ENV.fetch('RAILS_SCHEMA')}://#{ENV.fetch('DOMAIN_NAME')}:#{ENV.fetch('RAILS_PORT')}",
  prefix: 'derivations/image'
Shrine.plugin :rack_file
Shrine.plugin :determine_mime_type
# Shrine.plugin :presign_endpoint
# Shrine.plugin :download_endpoint
# Shrine.plugin :derivation_endpoint
# Shrine.plugin :rack_response
# Shrine.plugin :upload_endpoint,
#               upload: -> (io, options, request) {
#                 ImageUploader.upload(io, :cache, **options)
#               },
#               url: -> (uploaded_file, request) {
#                 derivation = uploaded_file.derivation(:thumbnail, 100, 100)
#                 derivation.processed
#                 derivation.url
#               }
