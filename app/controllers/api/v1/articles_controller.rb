# frozen_string_literal: true

module Api
  module V1
    # Blog functionality
    class ArticlesController < BaseController
      include ArticlePage

      def index
        articles = Article.page(params[:page]).per(per)
        render json: ArticleSerializer.new(
          articles,
          meta: { totalCount: articles.total_count }
        ).serialized_json
      end

      def show
        article = Article.find("#{params[:date]}_#{params[:title]}")
        render json: ArticleSerializer.new(article)
      end
    end
  end
end
