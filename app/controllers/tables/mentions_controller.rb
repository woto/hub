# frozen_string_literal: true

module Tables
  class MentionsController < ApplicationController
    ALLOWED_PARAMS = [:q, :per, :page, :sort, :order, { filters: {} }, { columns: [] }].freeze
    REQUIRED_PARAMS = %i[per order sort columns].freeze
    skip_before_action :authenticate_user!, only: [:index]

    include Workspaceable
    include Tableable
    layout 'backoffice'

    # GET /checks
    def index
      get_index(%w[id entity_ids])
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

    private

    def set_settings
      @settings = GlobalHelper.class_configurator('mention')
    end
  end
end
