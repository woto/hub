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
      get_index(%w[id], filter_ids: current_user.id)
    end

    private

    def set_settings
      @settings = { singular: :favorite,
                    plural: :favorites,
                    model_class: Favorite,
                    form_class: Columns::FavoriteForm,
                    query_class: FavoritesSearchQuery,
                    decorator_class: FavoriteDecorator,
                    favorites_kind: nil,
                    favorites_items_kind: nil
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
end
