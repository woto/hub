# frozen_string_literal: true

class Tables::PostCategoriesController < ApplicationController
  ALLOWED_PARAMS = %i[q per page sort order cols].freeze
  REQUIRED_PARAMS = %i[per cols].freeze

  include Workspaceable
  include Tableable
  layout 'backoffice'
  before_action :set_post_category, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!

  def index
    get_index([], nil)
  end

  private

  def set_post_category
    @post_category = PostCategory.find(params[:id])
  end

  def post_category_params
    params.require(:post_category).permit(:title, :realm_id, :parent_id)
  end

  def set_settings
    @settings = { singular: :post_category,
                  plural: :post_categories,
                  model_class: PostCategory,
                  form_class: Columns::PostCategoryForm,
                  query_class: PostCategoriesSearchQuery,
                  decorator_class: PostCategoryDecorator
    }
  end

  def system_default_workspace
    url_for(**workspace_params,
            cols: @settings[:form_class].default_stringified_columns_for(request),
            per: @pagination_rule.per,
            sort: :id,
            order: :desc)
  end
end
