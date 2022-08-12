# frozen_string_literal: true

module Columns
  class EntitiesMapping < BaseMapping
    DEFAULTS = %w[images title intro topics].freeze

    self.all_columns = [
      { key: 'id',                           pg: Entity.columns_hash['id'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'intro',                        pg: Entity.columns_hash['intro'], as: :string, roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'images',                       pg: Image.columns_hash['image_data'], as: :jsonb, roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'user_id',                      pg: Entity.columns_hash['user_id'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'title',                        pg: Entity.columns_hash['title'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'text_start',                   pg: Cite.columns_hash['text_start'], roles: ['user', 'manager', 'admin'] },
      { key: 'text_end',                     pg: Cite.columns_hash['text_end'], roles: ['user', 'manager', 'admin'] },
      { key: 'prefix',                       pg: Cite.columns_hash['prefix'], roles: ['user', 'manager', 'admin'] },
      { key: 'suffix',                       pg: Cite.columns_hash['suffix'], roles: ['user', 'manager', 'admin'] },
      { key: 'link_url',                     pg: Cite.columns_hash['link_url'], roles: ['user', 'manager', 'admin'] },
      { key: 'hostname',                     pg: Entity.columns_hash['hostname_id'], as: :string, roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'lookups',                      pg: Lookup.columns_hash['title'], as: :jsonb, roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'topics',                       pg: Topic.columns_hash['title'], as: :jsonb, roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'entities_mentions_count',      pg: Entity.columns_hash['entities_mentions_count'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'created_at',                   pg: Entity.columns_hash['created_at'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'updated_at',                   pg: Entity.columns_hash['updated_at'], roles: ['guest', 'user', 'manager', 'admin'] }
    ]
  end
end
