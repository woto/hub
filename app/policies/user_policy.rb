# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    return true if user && user.role.in?(['admin', 'manager'])
  end
end
