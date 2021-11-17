#  frozen_string_literal: true

module Accounting
  module Main
    class MentionStatusPolicy < ApplicationPolicy
      def initialize(user, context)
        raise Pundit::NotAuthorizedError, 'responsible is not set' unless user

        super
      end

      def to_draft_mention?
        return true if context.from_status.in?([nil, 'draft_mention', 'pending_mention', 'rejected_mention'])

        user.staff?
      end

      def to_pending_mention?
        return true if context.from_status.in?([nil, 'draft_mention', 'pending_mention', 'rejected_mention'])

        user.staff?
      end

      def to_approved_mention?
        user.staff?
      end

      def to_rejected_mention?
        user.staff?
      end

      def to_accrued_mention?
        user.staff?
      end

      def to_canceled_mention?
        user.staff?
      end

      def to_removed_mention?
        return true if context.from_status.in?(%w[draft_mention pending_mention rejected_mention])

        user.staff?
      end
    end
  end
end
