# frozen_string_literal: true

require 'shrine'
require 'shrine/storage/file_system'

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'), # temporary
  store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads') # permanent
}

Shrine.plugin :activerecord # or :activerecord
Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file
# Shrine.plugin :derivatives # allows storing processed files ("derivatives") alongside the main attached file
Shrine.plugin :derivation_endpoint, secret_key: Rails.application.secret_key_base
Shrine.plugin :upload_endpoint
Shrine.plugin :rack_file
Shrine.plugin :determine_mime_type
# Shrine.plugin :presign_endpoint
# Shrine.plugin :download_endpoint
# Shrine.plugin :derivation_endpoint
# Shrine.plugin :rack_response
