# frozen_string_literal: true

module Api
  module V1
    class PostsController < BaseController
      before_action :doorkeeper_authorize!

      def index
        render json: { items: Post.order(created_at: :desc), totalCount: Post.count }
      end

      def create
        Post.create!(post_params.merge(user: User.first))
      end

      private

      def post_params
        params.require(:post).permit(:url, :body)
      end
    end
  end
end
