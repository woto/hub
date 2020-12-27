# frozen_string_literal: true

class NewsController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'backoffice'

  def show
    @news = Post.find(params[:id])
  end

  private

  def path_for_switch_language(locale)
    news_index_path(locale)
  end
end
