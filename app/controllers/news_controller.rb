# frozen_string_literal: true

class NewsController < ApplicationController
  layout 'backoffice'
  skip_before_action :authenticate_user!

  # helper_method :by_months_menu, :by_tags_menu

  def show
    # repository = NewsRepository.new
    #  @news = repository.find(params[:id])
    @news = Post.find(params[:id])
  end
end
