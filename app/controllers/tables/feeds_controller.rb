# frozen_string_literal: true

module Tables
  class FeedsController < ApplicationController
    ALLOWED_PARAMS = %i[q per page sort order cols].freeze
    REQUIRED_PARAMS = %i[per cols].freeze

    include Workspaceable
    include Tableable
    layout 'backoffice'
    skip_before_action :authenticate_user!

    # GET /feeds
    def index
      get_index(%w[advertiser_id index_name], nil)
    end

    private

    def set_settings
      @settings = { singular: :feed,
                    plural: :feeds,
                    model_class: Feed,
                    form_class: Columns::FeedForm,
                    query_class: FeedsSearchQuery,
                    decorator_class: FeedDecorator }
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
