# frozen_string_literal: true

class NewsController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'website'

  def show
    @news = Post.find(params[:id])
    @post_category = @news.post_category
  end

  private

  def path_for_switch_language(locale)
    news_index_path(locale)
  end
end
