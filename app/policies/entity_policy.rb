# frozen_string_literal: true

class EntityPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(_user, scope)
      @scope = scope
    end

    def resolve
      scope
    end
  end

  def permitted_attributes
    [
      :title, :picture, :image, { aliases: [] }
    ]
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def update?
    true
  end

  def destroy?
    false
  end

end
