# frozen_string_literal: true

module Frames
  module News
    class LatestController < ApplicationController
      skip_before_action :authenticate_user!
      layout 'centered'

      def index
        @page = params[:page] || 0

        result = GlobalHelper.elastic_client.search(
          Frames::NewsLatestQuery.call(
            locale: I18n.locale,
            published_at: params[:published_at],
            from: @page,
            size: 1
          ).object
        )

        @news = result.dig('hits', 'hits', 0, '_source')

        result = GlobalHelper.elastic_client.count(
          Frames::NewsCountQuery.call(
            locale: I18n.locale
          ).object
        )

        @count = result['count'].to_i
      end
    end
  end
end
