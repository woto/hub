module Websites
  class CategoriesController < ActionController::Base
    layout 'website'

    def show
      @post_category = PostCategory.find(params[:id])
      @realm = @post_category.realm
      @posts = @post_category.posts
    end
  end
end
