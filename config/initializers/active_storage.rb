# https://github.com/rails/rails/issues/34665
Rails.application.config.active_storage.content_types_to_serve_as_binary.delete('image/svg+xml')
