# frozen_string_literal: true

module Columns
  class EntitiesMapping < BaseMapping
    DEFAULTS = %w[image title intro topics lookups].freeze

    self.all_columns = [
      { key: 'id',                  pg: Entity.columns_hash['id'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'intro',               pg: Entity.columns_hash['intro'], as: :string, roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'image',               pg: Entity.columns_hash['image_data'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'user_id',             pg: Entity.columns_hash['user_id'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'title',               pg: Entity.columns_hash['title'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'hostname',            pg: Entity.columns_hash['hostname_id'], as: :string, roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'lookups',             pg: Lookup.columns_hash['title'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'topics',              pg: Topic.columns_hash['title'], as: :string, roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'topics_count',        pg: Entity.columns_hash['topics_count'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'lookups_count',       pg: Entity.columns_hash['lookups_count'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'mentions_count',      pg: Entity.columns_hash['mentions_count'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'created_at',          pg: Entity.columns_hash['created_at'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'updated_at',          pg: Entity.columns_hash['updated_at'], roles: ['guest', 'user', 'manager', 'admin'] }
    ]
  end
end
