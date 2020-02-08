# frozen_string_literal: true

class ArticleSerializer
  include FastJsonapi::ObjectSerializer
  attributes :preview, :content, :meta
end
