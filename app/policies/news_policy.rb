# frozen_string_literal: true

class NewsPolicy < ApplicationPolicy
  def index?
    true
  end

  def by_month?
    true
  end

  def by_tag?
    true
  end

  def by_category?
    true
  end
end
