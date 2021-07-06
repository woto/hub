module Websites
  class ArticlesController < ActionController::Base
    layout 'website'

    def index
      @pagination_rule = PaginationRules.new(request, 12, 80,
                                             [2, 3, 4, 6, 8, 9, 10, 12, 21, 30, 33, 42, 80])

      if params[:id]
        @post_category = PostCategory.find(params[:id])
        @post_categories = PostCategory.order(:title).children_of(@post_category).arrange
        @realm = @post_category.realm
        @posts = @post_category.posts.order(published_at: :desc).page(@pagination_rule.page).per(@pagination_rule.per)
      else
        @post_categories = Current.realm.post_categories.order(:title).to_depth(0).arrange
        @realm = Current.realm
        @posts = Current.realm.posts.order(published_at: :desc).page(@pagination_rule.page).per(@pagination_rule.per)
      end
    end

    def show
      @post = Post.find(params[:id])
    end
  end
end
