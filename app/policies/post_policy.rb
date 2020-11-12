# frozen_string_literal: true

class PostPolicy < ApplicationPolicy
  def update?
    case record.status
    when 'draft', 'pending'
      return true
    when 'accrued', 'rejected', 'canceled'
      return true if user.role.in?(['admin', 'manager'])
    end
  end

  def create?
    true
  end
end
