# frozen_string_literal: true

module Api
  module V1
    module Staff
      class BaseController < ApplicationController
        respond_to :json

        before_action if: -> { Rails.env.production? } do
          head :forbidden
        end
      end
    end
  end
end
