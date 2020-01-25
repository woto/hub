# frozen_string_literal: true

module Api
  module V1
    # Blog functionality
    class ArticlesController < BaseController
      MAX_PER = 100
      DEFAULT_PER = 20
      def index
        per = params[:per].tap do |p|
          break DEFAULT_PER if p.nil?

          p = p.to_i
          p < MAX_PER ? p : MAX_PER
        end
        articles = Article.page(params[:page]).per(per)
        render json: ArticleSerializer.new(
          articles,
          meta: { totalCount: articles.total_count }
        ).serialized_json
      end

      def show
        article = Article.find(params[:id])
        render json: ArticleSerializer.new(article)
      end
    end
  end
end
