# frozen_string_literal: true

module Api
  module V1
    class PostsController < BaseController
      before_action :doorkeeper_authorize!

      def index
        render json: PostSerializer.new(
          Post.order(created_at: :desc),
          meta: { totalCount: Post.count }
        ).serialized_json
      end

      def create
        post = Post.create!(post_params.merge(user: current_user))
        render json: PostSerializer.new(post)
      end

      def update
        post = current_user.posts.find(params[:id])
        post.update(post_params)
        render json: PostSerializer.new(post)
      end

      def show
        post = current_user.posts.find(params[:id])
        render json: PostSerializer.new(post)
      end

      def images
        post = current_user.posts.find(params[:id])
        image = post.images.attach(params[:upload])
        render json: {
          url: rails_blob_path(image.first, disposition: 'attachment')
        }
      end

      private

      def post_params
        params.fetch(:post, {}).permit(:url, :body)
      end
    end
  end
end
