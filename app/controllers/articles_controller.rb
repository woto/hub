# frozen_string_literal: true

class ArticlesController < ApplicationController
  include ArticlePage
  layout 'dashboard'
  skip_before_action :authenticate_user!

  def index
    # TODO: Refactor. We should parse only those articles which will be shown
    article_paths = Dir["#{Article::ARTICLES_PATH}/*/*"]

    articles = article_paths.map do |article_path|
      Article::Parser.new(article_path).parse
    end
    articles.sort_by!(&:date)
    articles.reverse!

    @articles = Kaminari.paginate_array(articles).page(params[:page]).per(per)
  end

  def show
    @article = Article.find("#{params[:date]}/#{params[:title]}")
  end
end
