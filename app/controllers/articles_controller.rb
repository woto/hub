# frozen_string_literal: true

class ArticlesController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'website'

  def show
    @article = Post.find(params[:id])
    @article_category = @article.post_category
  end

  private

  def path_for_switch_language(locale)
    realm = Realm.news.find_by(locale: locale)
    if realm
      articles_url(host: realm.domain)
    else
      '/404'
    end
  end

  def url_for_search_everywhere
    articles_url(request.params.slice(:order, :per, :sort))
  end
end
