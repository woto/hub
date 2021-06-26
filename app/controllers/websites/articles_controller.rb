module Websites
  class ArticlesController < ActionController::Base
    layout 'website'

    def show
      @post = Post.find(params[:id])
    end
  end
end
