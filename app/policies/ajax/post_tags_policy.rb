# frozen_string_literal: true

module Ajax
  class PostTagsPolicy < ApplicationPolicy
    def index?
      true
    end
  end
end
