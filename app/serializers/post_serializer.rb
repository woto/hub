# frozen_string_literal: true

class PostSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :body, :url, :status_state, :updated_at
end
