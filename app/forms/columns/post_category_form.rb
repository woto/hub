# frozen_string_literal: true

module Columns
  class PostCategoryForm < BaseForm
    DEFAULTS = %w[id title realm_id path].freeze

    self.all_columns = [
      { key: 'id',                       pg: PostCategory.columns_hash['id'], roles: ['user', 'manager', 'admin'] },
      # { key: 'title_i18n.en',            pg: PostCategory.columns_hash['title_i18n'], as: :string, roles: %w[user manager admin] },
      # { key: 'title_i18n.ru',            pg: PostCategory.columns_hash['title_i18n'], as: :string, roles: %w[user manager admin] },
      { key: 'title',                    pg: PostCategory.columns_hash['title'], roles: %w[user manager admin] },
      { key: 'path',                     pg: PostCategory.columns_hash['ancestry'], roles: %w[user manager admin] },
      { key: 'realm_id',                 pg: PostCategory.columns_hash['realm_id'], roles: %w[user manager admin] },
      { key: 'leaf',                     pg: PostCategory.columns_hash['ancestry'], as: :boolean, roles: %w[user manager admin] },
      { key: 'priority',                 pg: PostCategory.columns_hash['priority'], roles: ['user', 'manager', 'admin'] }
    ]
  end
end
