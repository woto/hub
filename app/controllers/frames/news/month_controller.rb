# frozen_string_literal: true

module Frames
  module News
    class MonthController < ApplicationController
      skip_before_action :authenticate_user!
      layout 'centered'

      def index
        client = Elasticsearch::Client.new Rails.application.config.elastic

        @month = Time.zone.parse("#{params[:month]}-01") if params[:month]

        query = Widgets::NewsByMonthSearchQuery.call(
          locale: locale
        ).object

        @result = client.search(query)
      end
    end
  end
end
