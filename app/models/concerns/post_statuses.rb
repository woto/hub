# frozen_string_literal: true

# status
#
# draft:    <- nil, rejected, pending
#
# pending:  <- nil, draft, rejected
#
# accrued:  <- pending
#
# rejected: <- pending
#
# canceled: <- accrued

module PostStatuses
  extend ActiveSupport::Concern

  included do
    def to_pending
      unless PostStatusesPolicy.new(Current.responsible, self).to_pending?
        raise Pundit::NotAuthorizedError, "User with role `#{Current.responsible.role}` not allowed to Post#to_pending?"
      end

      case status_before_last_save
      when nil, 'draft', 'pending', 'rejected'
        change_pending('create_or_change_pending')
      else
        raise "wrong status transaction state: `#{status_previous_change}`"
      end
    end
    alias_method :to_draft, :to_pending

    def to_accrued
      unless PostStatusesPolicy.new(Current.responsible, self).to_accrued?
        raise Pundit::NotAuthorizedError, "User with role `#{Current.responsible.role}` not allowed to Post#to_accrued?"
      end

      case status_before_last_save
      when 'pending'
        pending_to_accrued
      else
        raise "wrong status transaction state: `#{status_previous_change}`"
      end
    end

    def to_rejected
      unless PostStatusesPolicy.new(Current.responsible, self).to_rejected?
        raise Pundit::NotAuthorizedError, "User with role `#{Current.responsible.role}` not allowed to Post#to_rejected?"
      end

      case status_before_last_save
      when 'pending'
        change_pending('rejected_to_pending')
      else
        raise "wrong status transaction state: `#{status_previous_change}`"
      end
    end

    def to_canceled
      unless PostStatusesPolicy.new(Current.responsible, self).to_canceled?
        raise Pundit::NotAuthorizedError, "User with role `#{Current.responsible.role}` not allowed to Post#to_canceled?"
      end

      case status_before_last_save
      when 'accrued'
        accrued_to_pending('accrued_to_canceled')
      else
        raise "wrong status transaction state: `#{status_previous_change}`"
      end
    end

    def change_pending(kind)
      group = TransactionGroup.create!(
        kind: kind
      )

      if price_before_last_save.to_d != 0
        Accounting::Actions::Post.call(
          hub: Account.hub_pending_usd,
          user: Account.for_user_pending_usd(user),
          amount: -price_before_last_save,
          group: group,
          obj: self
        )
      end

      Accounting::Actions::Post.call(
        hub: Account.hub_pending_usd,
        user: Account.for_user_pending_usd(user),
        amount: price,
        group: group,
        obj: self
      )
    end

    def change_accrued
      group = TransactionGroup.create!(
        kind: __method__
      )

      Accounting::Actions::Post.call(
        hub: Account.hub_accrued_usd,
        user: Account.for_user_accrued_usd(user),
        amount: -price_before_last_save,
        group: group,
        obj: self
      )

      Accounting::Actions::Post.call(
        hub: Account.hub_accrued_usd,
        user: Account.for_user_accrued_usd(user),
        amount: price,
        group: group,
        obj: self
      )
    end

    def pending_to_accrued
      group = TransactionGroup.create!(
        kind: __method__
      )

      Accounting::Actions::Post.call(
        hub: Account.hub_pending_usd,
        user: Account.for_user_pending_usd(user),
        amount: -price_before_last_save,
        group: group,
        obj: self
      )

      Accounting::Actions::Post.call(
        hub: Account.hub_accrued_usd,
        user: Account.for_user_accrued_usd(user),
        amount: price,
        group: group,
        obj: self
      )
    end

    def accrued_to_pending(kind)
      group = TransactionGroup.create!(
        kind: kind
      )

      Accounting::Actions::Post.call(
        hub: Account.hub_accrued_usd,
        user: Account.for_user_accrued_usd(user),
        amount: -price_before_last_save,
        group: group,
        obj: self
      )

      Accounting::Actions::Post.call(
        hub: Account.hub_pending_usd,
        user: Account.for_user_pending_usd(user),
        amount: price,
        group: group,
        obj: self
      )
    end
  end
end
