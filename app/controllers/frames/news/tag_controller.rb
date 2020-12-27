# frozen_string_literal: true

module Frames
  module News
    class TagController < ApplicationController
      skip_before_action :authenticate_user!
      layout 'centered'

      def index
        client = Elasticsearch::Client.new Rails.application.config.elastic

        @tag = params[:tag]

        query = Widgets::NewsByTagSearchQuery.call(
          locale: locale
        ).object

        @result = client.search(query)
      end
    end
  end
end
