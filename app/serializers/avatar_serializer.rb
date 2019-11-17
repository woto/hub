# frozen_string_literal: true

class AvatarSerializer
  include FastJsonapi::ObjectSerializer

  attribute :url do |object|
    Rails.application.routes.url_helpers.rails_blob_path(object, only_path: true)
  end
end
