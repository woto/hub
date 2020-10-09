# frozen_string_literal: true

module Columns
  class PostForm < BaseForm
    DEFAULTS = %w[id title body status_state updated_at].freeze

    self.all_columns = [
      { key: 'id',                  pg: Post.columns_hash['id'] },
      { key: 'status_state',        pg: Post.columns_hash['status_state'] },
      { key: 'title',               pg: Post.columns_hash['title'] },
      { key: 'body',                pg: ActionText::RichText.columns_hash['body'], as: :text },
      { key: 'created_at',          pg: Post.columns_hash['created_at'] },
      { key: 'updated_at',          pg: Post.columns_hash['updated_at'] },
    ]
  end
end
