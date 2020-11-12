# frozen_string_literal: true

module Columns
  class PostCategoryForm < BaseForm
    DEFAULTS = %w[id title path].freeze

    self.all_columns = [
        { key: 'title',                    pg: PostCategory.columns_hash['title'], roles: ['user', 'manager', 'admin'] },
        { key: 'path',                     pg: PostCategory.columns_hash['ancestry'], roles: ['user', 'manager', 'admin'] },
        { key: 'leaf',                     pg: PostCategory.columns_hash['ancestry'], as: :boolean, roles: ['user', 'manager', 'admin'] },
    ]
  end
end
