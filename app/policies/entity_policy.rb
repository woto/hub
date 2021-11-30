# frozen_string_literal: true

class EntityPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def permitted_attributes
    attributes = [
      :title, :picture, :image, { lookups_attributes: %i[id title _destroy] }
    ]
    attributes.append(:user_id) if user.staff?
    attributes
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
    return true if super

    true if context.user == user
  end

  def destroy?
    return true if super

    true if context.user == user
  end
end
