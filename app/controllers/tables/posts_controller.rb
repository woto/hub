# frozen_string_literal: true

module Tables
  class PostsController < ApplicationController
    ALLOWED_PARAMS = [:q, :per, :page, :sort, :order, { filters: {} }, { columns: [] }].freeze
    REQUIRED_PARAMS = %i[per order sort columns].freeze

    include Workspaceable
    include Tableable
    layout 'backoffice'

    # GET /posts
    def index
      get_index(%w[id currency], filter_ids: ([current_user.id] unless current_user.staff?))
    end

    def set_settings
      @settings = GlobalHelper.class_configurator('post')
    end

    # TODO: action?!
    def workspace
      OpenStruct.new(
        **workspace_params,
        columns: @settings[:form_class]::DEFAULTS,
        per: @pagination_rule.per,
        sort: 'id',
        order: 'desc'
      )
    end
  end
end
