# frozen_string_literal: true

module Frames
  module News
    class CategoryController < ApplicationController
      skip_before_action :authenticate_user!
      layout 'centered'

      def index
        @post_category_id = params[:category_id]
        @post_category = PostCategory.find_by(id: @post_category_id)

        query = Frames::NewsByCategoryQuery.call(
          post_category_id: @post_category_id,
          locale: locale
        ).object

        @result = GlobalHelper.elastic_client.search(query)
      end
    end
  end
end
