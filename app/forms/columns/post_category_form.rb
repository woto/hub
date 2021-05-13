# frozen_string_literal: true

module Columns
  class PostCategoryForm < BaseForm
    DEFAULTS = %w[id title realm_id path].freeze

    self.all_columns = [
      { key: 'id',                       pg: PostCategory.columns_hash['id'], roles: %w[guest user manager admin] },
      { key: 'title',                    pg: PostCategory.columns_hash['title'], roles: %w[guest user manager admin] },
      { key: 'path',                     pg: PostCategory.columns_hash['ancestry'], roles: %w[guest user manager admin] },
      { key: 'realm_id',                 pg: PostCategory.columns_hash['realm_id'], roles: %w[guest user manager admin] },
      { key: 'realm_title',              pg: Realm.columns_hash['title'], roles: %w[guest user manager admin] },
      { key: 'realm_locale',             pg: Realm.columns_hash['locale'], roles: %w[guest user manager admin] },
      { key: 'realm_kind',               pg: Realm.columns_hash['kind'], as: :string, roles: %w[guest user manager admin] },
      { key: 'leaf',                     pg: PostCategory.columns_hash['ancestry'], as: :boolean, roles: %w[user manager admin] },
      { key: 'ancestry_depth',           pg: PostCategory.columns_hash['ancestry_depth'], roles: %w[manager admin] },
      { key: 'posts_count',              pg: PostCategory.columns_hash['posts_count'], roles: %w[manager admin] },
    ]
  end
end
