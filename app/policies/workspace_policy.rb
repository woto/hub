# frozen_string_literal: true

class WorkspacePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def destroy?
    return true if super

    true if context.user == user
  end
end
