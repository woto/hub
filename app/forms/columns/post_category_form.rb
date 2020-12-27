# frozen_string_literal: true

module Columns
  class PostCategoryForm < BaseForm
    DEFAULTS = %w[id title realm_id path].freeze

    self.all_columns = [
      { key: 'id',                       pg: PostCategory.columns_hash['id'], roles: ['guest', 'user', 'manager', 'admin'] },
      # { key: 'title_i18n.en',            pg: PostCategory.columns_hash['title_i18n'], as: :string, roles: %w[user manager admin] },
      # { key: 'title_i18n.ru',            pg: PostCategory.columns_hash['title_i18n'], as: :string, roles: %w[user manager admin] },
      { key: 'title',                    pg: PostCategory.columns_hash['title'], roles: %w[user manager admin] },
      { key: 'path',                     pg: PostCategory.columns_hash['ancestry'], roles: %w[user manager admin] },
      { key: 'realm_id',                 pg: PostCategory.columns_hash['realm_id'], roles: %w[user manager admin] },
      { key: 'realm_title',              pg: Realm.columns_hash['title'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'realm_locale',             pg: Realm.columns_hash['locale'], roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'realm_kind',               pg: Realm.columns_hash['kind'], as: :string, roles: ['guest', 'user', 'manager', 'admin'] },
      { key: 'leaf',                     pg: PostCategory.columns_hash['ancestry'], as: :boolean, roles: %w[user manager admin] },
      { key: 'priority',                 pg: PostCategory.columns_hash['priority'], roles: ['guest', 'user', 'manager', 'admin'] }
    ]
  end
end
