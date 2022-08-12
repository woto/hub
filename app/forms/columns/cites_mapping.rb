# frozen_string_literal: true

module Columns
  class CitesMapping < BaseMapping
    DEFAULTS = %w[id entity_id text_start].freeze

    self.all_columns = [
        { key: 'id',                  pg: Cite.columns_hash['id'], roles: ['user', 'manager', 'admin'] },
        { key: 'entity_id',           pg: Cite.columns_hash['entity_id'], roles: ['user', 'manager', 'admin'] },
        { key: 'location_url',        pg: Cite.columns_hash['location_url'], roles: ['user', 'manager', 'admin'] },
        { key: 'title',               pg: Cite.columns_hash['title'], roles: ['user', 'manager', 'admin'] },
        { key: 'intro',               pg: Cite.columns_hash['intro'], roles: ['user', 'manager', 'admin'] },
        { key: 'text_start',          pg: Cite.columns_hash['text_start'], roles: ['user', 'manager', 'admin'] },
        { key: 'text_end',            pg: Cite.columns_hash['text_end'], roles: ['user', 'manager', 'admin'] },
        { key: 'prefix',              pg: Cite.columns_hash['prefix'], roles: ['user', 'manager', 'admin'] },
        { key: 'suffix',              pg: Cite.columns_hash['suffix'], roles: ['user', 'manager', 'admin'] },
        # { key: 'priority',            pg: Cite.columns_hash['priority'], roles: ['user', 'manager', 'admin'] },
        { key: 'link_url',            pg: Cite.columns_hash['link_url'], roles: ['user', 'manager', 'admin'] },
        { key: 'relevance',           pg: Cite.columns_hash['relevance'], roles: ['user', 'manager', 'admin'] },
        { key: 'sentiment',           pg: Cite.columns_hash['sentiment'], roles: ['user', 'manager', 'admin'] }
    ]
  end
end
