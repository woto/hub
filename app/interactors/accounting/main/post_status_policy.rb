#  frozen_string_literal: true

module Accounting
  module Main
    class PostStatusPolicy < ApplicationPolicy
      def initialize(user, record)
        raise Pundit::NotAuthorizedError, 'responsible is not set' unless user

        super
      end

      def to_draft?
        return true if record.from_status.in?([nil, 'draft', 'pending', 'rejected'])

        user.role.in?(%w[admin manager])
      end

      def to_pending?
        return true if record.from_status.in?([nil, 'draft', 'pending', 'rejected'])

        user.role.in?(%w[admin manager])
      end

      def to_approved?
        user.role.in?(%w[admin manager])
      end

      def to_rejected?
        user.role.in?(%w[admin manager])
      end

      def to_accrued?
        user.role.in?(%w[admin manager])
      end

      def to_canceled?
        user.role.in?(%w[admin manager])
      end
    end
  end
end
