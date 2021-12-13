# frozen_string_literal: true

module Columns
  class TopicsMapping < BaseMapping
    DEFAULTS = %w[].freeze

    self.all_columns = [
      { key: 'id',                  pg: Topic.columns_hash['id'], roles: ['user', 'manager', 'admin'] },
      { key: 'title',               pg: Topic.columns_hash['title'], roles: ['user', 'manager', 'admin'] },
      { key: 'mentions_count',      pg: Topic.columns_hash['mentions_count'], roles: ['user', 'manager', 'admin'] },
      { key: 'created_at',          pg: Topic.columns_hash['created_at'], roles: ['user', 'manager', 'admin'] },
      { key: 'updated_at',          pg: Topic.columns_hash['updated_at'], roles: ['user', 'manager', 'admin'] }
    ]
  end
end
