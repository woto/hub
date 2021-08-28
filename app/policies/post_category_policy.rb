# frozen_string_literal: true

class PostCategoryPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end
end
