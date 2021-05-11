# frozen_string_literal: true

module Columns
  class RealmForm < BaseForm
    DEFAULTS = %w[id kind locale title post_categories_count posts_count].freeze

    self.all_columns = [
      { key: 'id',                    pg: Realm.columns_hash['id'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'domain',                pg: Realm.columns_hash['domain'], as: :string, roles: ['manager', 'admin'] },
      { key: 'kind',                  pg: Realm.columns_hash['kind'], as: :string, roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'locale',                pg: Realm.columns_hash['locale'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'post_categories_count', pg: Realm.columns_hash['post_categories_count'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'posts_count',           pg: Realm.columns_hash['posts_count'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'title',                 pg: Realm.columns_hash['title'], roles: ['guest', 'user', 'manager', 'admin'] },
    ]
  end
end
