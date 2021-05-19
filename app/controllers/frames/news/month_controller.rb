
# frozen_string_literal: true

module Frames
  module News
    class MonthController < ApplicationController
      skip_before_action :authenticate_user!
      layout 'centered'

      def index
        @month = Time.use_zone('UTC') { Time.zone.parse("#{params[:month]}-01") } if params[:month]

        query = Frames::NewsByMonthSearchQuery.call(
          locale: locale
        ).object

        @result = GlobalHelper.elastic_client.search(query)
      end
    end
  end
end
