# frozen_string_literal: true

class RolePolicy < ApplicationPolicy
  include RolesConstants

  def manage_applications?
    true if @user.role.in? [ROOT, ADMIN]
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
