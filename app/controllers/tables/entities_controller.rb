# frozen_string_literal: true

module Tables
  class EntitiesController < ApplicationController
    layout 'mentions'

    ALLOWED_PARAMS = [:q, :per, :page, :sort, :order, { filters: {} }, { columns: [] }].freeze
    REQUIRED_PARAMS = %i[per order sort columns].freeze
    skip_before_action :authenticate_user!, only: [:index]

    include Workspaceable
    include Tableable

    # GET /entities
    def index
      seo.noindex!
      get_index(%w[id])
    end

    # TODO: action?!
    def workspace
      @workspace = OpenStruct.new(
        **workspace_params,
        columns: @settings[:form_class]::DEFAULTS,
        per: @pagination_rule.per
      )

      unless params[:q]
        @workspace[:sort] = 'updated_at'
        @workspace[:order] = 'desc'
      end

      @workspace
    end

    private

    def set_settings
      @settings = GlobalHelper.class_configurator('entity')
    end
  end
end
