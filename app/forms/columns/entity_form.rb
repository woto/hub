# frozen_string_literal: true

module Columns
  class EntityForm < BaseForm
    DEFAULTS = %w[id image title aliases created_at].freeze

    self.all_columns = [
      { key: 'id',                  pg: Entity.columns_hash['id'], roles: ['user', 'manager', 'admin'] },
      { key: 'image',               pg: Entity.columns_hash['image_data'], as: :string, roles: ['user', 'manager', 'admin'] },
      { key: 'user_id',             pg: Entity.columns_hash['user_id'], roles: ['manager', 'admin'] },
      { key: 'title',               pg: Entity.columns_hash['title'], roles: ['user', 'manager', 'admin'] },
      { key: 'aliases',             pg: Entity.columns_hash['aliases'], as: :text, roles: ['user', 'manager', 'admin'] },
      { key: 'mentions_count',      pg: Entity.columns_hash['mentions_count'], roles: ['user', 'manager', 'admin'] },
      { key: 'created_at',          pg: Entity.columns_hash['created_at'], roles: ['user', 'manager', 'admin'] },
      { key: 'updated_at',          pg: Entity.columns_hash['updated_at'], roles: ['user', 'manager', 'admin'] }
    ]
  end
end
