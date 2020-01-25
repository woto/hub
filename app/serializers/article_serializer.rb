# frozen_string_literal: true

class ArticleSerializer
  include FastJsonapi::ObjectSerializer
  attributes :created_at, :preview, :content
end
