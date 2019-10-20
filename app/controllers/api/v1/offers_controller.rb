# frozen_string_literal: true

module Api
  module V1
    # Offers list
    class OffersController < BaseController

      def index
        @result = Elastic.call(params)
        render json: { items: @result[:offers], totalCount: @result[:count] }
      end

    end
  end
end