# frozen_string_literal: true

module Ajax
  class PostCategoriesPolicy < ApplicationPolicy
    def index?
      true
    end
  end
end
