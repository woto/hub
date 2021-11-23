# frozen_string_literal: true

class EntityPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      raise Pundit::NotAuthorizedError, 'responsible is not set' unless user

      if user.staff?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end

  def permitted_attributes
    attributes = [
      :title, :picture, :image, { aliases: [] }
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
