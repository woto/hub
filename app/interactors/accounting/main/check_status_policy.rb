# frozen_string_literal: true

module Accounting
  module Main
    class CheckStatusPolicy < ApplicationPolicy
      def initialize(user, context)
        raise Pundit::NotAuthorizedError, 'responsible is not set' unless user

        super
      end

      def to_pending_check?
        return true if context.from_status.in?([nil, 'pending_check'])

        user.staff?
      end

      def to_approved_check?
        user.staff?
      end

      def to_payed_check?
        user.staff?
      end

      def to_removed_check?
        return true if context.from_status.in?(%w[pending_check])

        user.staff?
      end
    end
  end
end
