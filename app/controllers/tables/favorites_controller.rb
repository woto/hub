# frozen_string_literal: true

module Tables
  class FavoritesController < ApplicationController
    ALLOWED_PARAMS = %i[q per page sort order cols].freeze
    REQUIRED_PARAMS = %i[per order sort cols].freeze

    include Workspaceable
    include Tableable
    layout 'backoffice'

    # GET /favorites
    def index
      get_index([], filter_ids: (current_user.id if current_user.role == 'user'))
    end

    private

    def set_settings
      @settings = { singular: :favorite,
                    plural: :favorites,
                    model_class: Favorite,
                    form_class: Columns::FavoriteForm,
                    query_class: FavoritesSearchQuery,
                    decorator_class: FavoriteDecorator }
    end

    def system_default_workspace
      url_for(**workspace_params,
              cols: @settings[:form_class].default_stringified_columns_for(request),
              per: @pagination_rule.per,
              sort: :id,
              order: :desc)
    end

    def set_preserved_search_params
      @preserved_search_params = %i[order per sort q]
    end
  end
end
