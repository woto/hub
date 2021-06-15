# frozen_string_literal: true

module Widgets
  class SimplePolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope.where(user: user)
      end
    end

    def create?
      true
    end

    def update?
      return true if super

      true if context.widget.user == user
    end
  end
end
