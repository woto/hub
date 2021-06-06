# frozen_string_literal: true

class CheckPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      raise Pundit::NotAuthorizedError, 'responsible is not set' unless user

      if user.role.in?(%w[admin manager])
        scope.all
      else
        scope.where(user: user)
      end
    end
  end

  def permitted_attributes
    attributes = %i[amount currency status]
    attributes << :user_id if user.role.in?(%w[admin manager])
    attributes
  end

  def update?
    return true if super

    true if context.user == user && context.pending_check?
  end

  def create?
    true
  end

  def index?
    true
  end

  def show?
    return true if super

    true if context.user == user
  end

  def destroy?
    return true if super

    true if context.user == user && context.pending_check?
  end
end
