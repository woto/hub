# frozen_string_literal: true

class CheckPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def update?
    case record.is_payed
    when false
      return true if user.role.in?(['admin', 'manager'])
    end
  end

  def create?
    true
  end

  def index?
    true
  end
end
