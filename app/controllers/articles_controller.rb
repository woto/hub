# frozen_string_literal: true

class ArticlesController < ApplicationController
  include ArticlePage

  def index
    @articles = Article.page(params[:page]).per(per)
  end

  def show
    @article = Article.find("#{params[:date]}_#{params[:title]}")
    render 'show'
  end

end
