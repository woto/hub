# frozen_string_literal: true

module Columns
  class MentionsMapping < BaseMapping
    DEFAULTS = %w[image title entities created_at].freeze

    self.all_columns = [
        { key: 'image',               pg: Mention.columns_hash['image_data'], roles: ['guest', 'user', 'manager', 'admin'] },
        { key: 'user_id',             pg: Mention.columns_hash['user_id'], roles: ['guest', 'user', 'manager', 'admin'] },
        { key: 'url',                 pg: Mention.columns_hash['url'], roles: ['guest', 'user', 'manager', 'admin'] },
        { key: 'title',               pg: Mention.columns_hash['title'], roles: ['guest', 'user', 'manager', 'admin'] },
        { key: 'entities',            pg: Mention.columns_hash['id'], as: :jsonb, roles: ['guest', 'user', 'manager', 'admin'] },
        { key: 'entity_ids',          pg: Mention.columns_hash['id'], as: :integer, roles: ['guest', 'user', 'manager', 'admin'] },
        { key: 'topics',              pg: Topic.columns_hash['title'], as: :string, roles: ['guest', 'user', 'manager', 'admin'] },
        { key: 'published_at',        pg: Mention.columns_hash['published_at'], roles: ['guest', 'user', 'manager', 'admin'] },
        { key: 'kinds',               pg: Mention.columns_hash['kinds'], as: :string, roles: %w[guest user manager admin] },
        { key: 'sentiment',           pg: Mention.columns_hash['sentiment'], as: :string, roles: %w[guest user manager admin] },
        { key: 'entities_count',      pg: Mention.columns_hash['entities_count'], roles: ['guest', 'user', 'manager', 'admin'] },
        { key: 'topics_count',        pg: Mention.columns_hash['topics_count'], as: :integer, roles: ['guest', 'user', 'manager', 'admin'] },
        { key: 'created_at',          pg: Mention.columns_hash['created_at'], roles: ['guest', 'user', 'manager', 'admin'] },
        { key: 'updated_at',          pg: Mention.columns_hash['updated_at'], roles: ['guest', 'user', 'manager', 'admin'] },
    ]
  end
end
