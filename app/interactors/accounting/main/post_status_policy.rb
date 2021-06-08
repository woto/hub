#  frozen_string_literal: true

module Accounting
  module Main
    class PostStatusPolicy < ApplicationPolicy
      def initialize(user, context)
        raise Pundit::NotAuthorizedError, 'responsible is not set' unless user

        super
      end

      def to_draft_post?
        return true if context.from_status.in?([nil, 'draft_post', 'pending_post', 'rejected_post'])

        user.staff?
      end

      def to_pending_post?
        return true if context.from_status.in?([nil, 'draft_post', 'pending_post', 'rejected_post'])

        user.staff?
      end

      def to_approved_post?
        user.staff?
      end

      def to_rejected_post?
        user.staff?
      end

      def to_accrued_post?
        user.staff?
      end

      def to_canceled_post?
        user.staff?
      end

      def to_removed_post?
        return true if context.from_status.in?(%w[draft_post pending_post rejected_post])

        user.staff?
      end
    end
  end
end
