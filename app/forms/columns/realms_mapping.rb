# frozen_string_literal: true

module Columns
  class RealmsMapping < BaseMapping
    DEFAULTS = %w[id domain kind locale title post_categories_count posts_count].freeze

    self.all_columns = [
      { key: 'id',                    pg: Realm.columns_hash['id'], roles: %w[guest user manager admin] },
      { key: 'domain',                pg: Realm.columns_hash['domain'], as: :string, roles: %w[manager admin] },
      { key: 'kind',                  pg: Realm.columns_hash['kind'], as: :string, roles: %w[guest user manager admin] },
      { key: 'locale',                pg: Realm.columns_hash['locale'], roles: %w[guest user manager admin] },
      { key: 'post_categories_count', pg: Realm.columns_hash['post_categories_count'], roles: %w[guest user manager admin] },
      { key: 'posts_count',           pg: Realm.columns_hash['posts_count'], roles: %w[guest user manager admin] },
      { key: 'title',                 pg: Realm.columns_hash['title'], roles: %w[guest user manager admin] },
      { key: 'created_at',            pg: Realm.columns_hash['created_at'], roles: %w[guest user manager admin] },
      { key: 'updated_at',            pg: Realm.columns_hash['updated_at'], roles: %w[guest user manager admin] },
    ]
  end
end
