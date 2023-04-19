# frozen_string_literal: true

module Frames
  module Articles
    class TagController < ApplicationController
      skip_before_action :authenticate_user!
      layout 'centered'

      def index
        @tag = params[:tag]

        query = Frames::NewsByTagSearchQuery.call(
          locale: locale
        ).object

        @result = GlobalHelper.elastic_client.search(query)
      end
    end
  end
end
