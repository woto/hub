module Websites
  class RealmsController < ActionController::Base
    layout 'website'

    def show
      @pagination_rule = PaginationRules.new(request, 12, 80,
                                             [2, 3, 4, 6, 8, 9, 10, 12, 21, 30, 33, 42, 80])
      @posts = Current.realm.posts.order(published_at: :desc).page(@pagination_rule.page).per(@pagination_rule.per)
    end
  end
end
