# frozen_string_literal: true

class ArticlesController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'website'

  def show
    realm = Current.realm
    @article = realm.posts.find(params[:id])
    @article_category = @article.post_category
    response.headers['Link'] = %(<#{article_url(id: @article, host: realm.domain, locale: nil)}>; rel="canonical")
  end

  private

  def path_for_switch_language(locale, kind)
    realm = Realm.find_by(locale: locale, kind: kind)
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
