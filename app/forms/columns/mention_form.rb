# frozen_string_literal: true

module Columns
  class MentionForm < BaseForm
    DEFAULTS = %w[id image url entities tags created_at].freeze

    self.all_columns = [
        { key: 'id',                  pg: Mention.columns_hash['id'], roles: ['user', 'manager', 'admin'] },
        { key: 'image',               pg: Mention.columns_hash['image_data'], as: :string, roles: ['user', 'manager', 'admin'] },
        { key: 'user_id',             pg: Mention.columns_hash['user_id'], roles: ['manager', 'admin'] },
        { key: 'url',                 pg: Mention.columns_hash['url'], roles: ['user', 'manager', 'admin'] },
        { key: 'entities',            pg: Mention.columns_hash['id'], as: :string, roles: ['user', 'manager', 'admin'] },
        { key: 'entity_ids',          pg: Mention.columns_hash['id'], as: :integer, roles: ['user', 'manager', 'admin'] },
        { key: 'tags',                pg: Mention.columns_hash['tags'], as: :string, roles: ['user', 'manager', 'admin'] },
        { key: 'published_at',        pg: Mention.columns_hash['published_at'], roles: ['user', 'manager', 'admin'] },
        { key: 'kind',                pg: Mention.columns_hash['kind'], as: :string, roles: %w[guest user manager admin] },
        { key: 'sentiment',           pg: Mention.columns_hash['sentiment'], as: :string, roles: %w[guest user manager admin] },
        { key: 'entities_count',      pg: Mention.columns_hash['entities_count'], roles: ['user', 'manager', 'admin'] },
        { key: 'created_at',          pg: Mention.columns_hash['created_at'], roles: ['user', 'manager', 'admin'] },
        { key: 'updated_at',          pg: Mention.columns_hash['updated_at'], roles: ['user', 'manager', 'admin'] },
    ]
  end
end
