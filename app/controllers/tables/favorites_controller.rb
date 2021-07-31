# frozen_string_literal: true

module Tables
  class FavoritesController < ApplicationController
    ALLOWED_PARAMS = [:q, :per, :page, :sort, :order, { filters: {} }, { columns: [] }].freeze
    REQUIRED_PARAMS = %i[per order sort columns].freeze

    include Workspaceable
    include Tableable
    layout 'backoffice'

    # GET /favorites
    def index
      get_index(%w[id], filter_ids: current_user.id)
    end

    private

    def set_settings
      @settings = GlobalHelper.class_configurator('favorite')
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
