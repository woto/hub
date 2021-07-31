# frozen_string_literal: true

module Tables
  class PostCategoriesController < ApplicationController
    ALLOWED_PARAMS = [:q, :per, :page, :sort, :order, { filters: {} }, { columns: [] }].freeze
    REQUIRED_PARAMS = %i[per order sort columns].freeze

    include Workspaceable
    include Tableable
    layout 'backoffice'
    skip_before_action :authenticate_user!

    # GET /post_categories
    def index
      get_index(%w[id])
    end

    private

    def set_settings
      @settings = GlobalHelper.class_configurator('post_category')
    end

    def system_default_workspace
      url_for(**workspace_params,
              columns: @settings[:form_class]::DEFAULTS,
              per: @pagination_rule.per,
              sort: :id,
              order: :desc)
    end
  end
end
