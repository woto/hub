# frozen_string_literal: true

module Columns
  class FavoriteForm < BaseForm
    DEFAULTS = %w[id name kind is_default favorites_items_count].freeze

    self.all_columns = [
      { key: 'id',                    pg: Favorite.columns_hash['id'], roles: ['user', 'manager', 'admin'] },
      { key: 'name',                  pg: Favorite.columns_hash['name'], roles: ['user', 'manager', 'admin'] },
      { key: 'kind',                  pg: Favorite.columns_hash['kind'], as: :string, roles: ['user', 'manager', 'admin'] },
      { key: 'is_default',            pg: Favorite.columns_hash['is_default'], roles: ['user', 'manager', 'admin'] },
      { key: 'favorites_items_count', pg: Favorite.columns_hash['favorites_items_count'], roles: ['user', 'manager', 'admin'] },
      { key: 'created_at',            pg: Favorite.columns_hash['created_at'], roles: ['user', 'manager', 'admin'] },
      { key: 'updated_at',            pg: Favorite.columns_hash['updated_at'], roles: ['user', 'manager', 'admin'] },
      { key: 'user_id',               pg: Favorite.columns_hash['user_id'], roles: ['user', 'manager', 'admin'] }
    ]
  end
end
