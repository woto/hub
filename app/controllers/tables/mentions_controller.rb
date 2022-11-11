# frozen_string_literal: true

module Tables
  class MentionsController < ApplicationController
    layout 'roastme/pages'
    ALLOWED_PARAMS = [:q, :per, :page, :sort, :order, { filters: {} }, { columns: [] }].freeze
    REQUIRED_PARAMS = %i[per order sort columns].freeze
    skip_before_action :authenticate_user!, only: [:index]

    include Workspaceable
    include Tableable

    # GET /checks
    def index
      seo.noindex!
    end

    # TODO: action?!
    def workspace
      @workspace = OpenStruct.new(
        **workspace_params,
        columns: @settings[:form_class]::DEFAULTS,
        per: @pagination_rule.per,
      )

      unless params[:q]
        @workspace[:sort] = 'updated_at'
        @workspace[:order] = 'desc'
      end

      @workspace
    end

    private

    def set_settings
      @settings = GlobalHelper.class_configurator('mention')
    end
  end
end
