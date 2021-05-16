# frozen_string_literal: true

module Accounting
  module Main
    class CheckStatusPolicy < ApplicationPolicy
      def initialize(user, context)
        raise Pundit::NotAuthorizedError, 'responsible is not set' unless user

        super
      end

      def to_requested?
        return true if context.from_status.in?([nil, 'requested'])

        user.role.in?(%w[admin manager])
      end

      def to_processing?
        user.role.in?(%w[admin manager])
      end

      def to_payed?
        user.role.in?(%w[admin manager])
      end
    end
  end
end
