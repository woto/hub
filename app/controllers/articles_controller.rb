# frozen_string_literal: true

class ArticlesController < ApplicationController
  ALLOWED_PARAMS = [:per, :page]
  REQUIRED_PARAMS = [:per]

  layout 'backoffice'
  include Workspaceable
  skip_before_action :authenticate_user!

  def index
    # TODO: Refactor. We should parse only those articles which will be shown
    article_paths = Dir["#{Article::ARTICLES_PATH}/*/*"]

    articles = article_paths.map do |article_path|
      Article::Parser.new(article_path).parse
    end
    articles.sort_by!(&:date)
    articles.reverse!

    @articles = Kaminari.paginate_array(articles).page(@pagination_rule.page).per(@pagination_rule.per)
  end

  def show
    @article = Article.find("#{params[:date]}/#{params[:title]}")
  end

  private

  def set_settings
    @settings = { singular: :article,
                  plural: :articles,
                  model_class: Article
                  # form_class: Columns::ArticleForm
    }
  end

  def set_pagination_rule
    @pagination_rule = PaginationRules.new(request)
  end

  def redirect_with_defaults
    redirect_to url_for(**workspace_params,
                        per: @pagination_rule.per)
  end

end
