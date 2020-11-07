module Paginatable
  extend ActiveSupport::Concern

  included do
    before_action :set_pagination_rule

    def set_pagination_rule
      @pagination_rule = PaginationRules.new(request)
    end
  end
end
