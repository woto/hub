# frozen_string_literal: true

module Accounting
  module Posts
    class StatusPolicy < ApplicationPolicy
      def to_pending?
        true
        # TODO
        # record.attribute_before_last_save(:status).in?([nil, 'draft', 'pending', 'rejected'])
      end

      def to_draft?
        true
        # TODO
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
