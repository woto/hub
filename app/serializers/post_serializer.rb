# frozen_string_literal: true

class PostSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :title, :body, :url, :status_state, :created_at, :updated_at
end
