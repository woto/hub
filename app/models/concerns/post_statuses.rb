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
      unless PostStatusesPolicy.new(Current.user, self).to_pending?
        raise Pundit::NotAuthorizedError, "User with role `#{Current.user.role}` not allowed to Post#to_pending?"
      end

      case status_before_last_save
      when nil, 'draft', 'pending', 'rejected'
        change_pending
      else
        raise "wrong status transaction state: `#{status_previous_change}`"
      end
    end
    alias_method :to_draft, :to_pending

    def to_accrued
      unless PostStatusesPolicy.new(Current.user, self).to_accrued?
        raise Pundit::NotAuthorizedError, "User with role `#{Current.user.role}` not allowed to Post#to_accrued?"
      end

      case status_before_last_save
      when 'pending'
        pending_to_accrued
      else
        raise "wrong status transaction state: `#{status_previous_change}`"
      end
    end

    def to_rejected
      unless PostStatusesPolicy.new(Current.user, self).to_rejected?
        raise Pundit::NotAuthorizedError, "User with role `#{Current.user.role}` not allowed to Post#to_rejected?"
      end

      case status_before_last_save
      when 'pending'
        change_pending
      else
        raise "wrong status transaction state: `#{status_previous_change}`"
      end
    end

    def to_canceled
      unless PostStatusesPolicy.new(Current.user, self).to_canceled?
        raise Pundit::NotAuthorizedError, "User with role `#{Current.user.role}` not allowed to Post#to_canceled?"
      end

      case status_before_last_save
      when 'accrued'
        accrued_to_pending('accrued_to_canceled')
      else
        raise "wrong status transaction state: `#{status_previous_change}`"
      end
    end

    def change_pending
      if price_before_last_save.to_i != 0
        Accounting::Actions::PendingPost.call(
          hub: Account.find_by!(name: 'hub_pending'),
          user: user.accounts.find_by!(name: "##{user_id}_user_pending"),
          amount: -price_before_last_save,
          object: self
        )
      end

      Accounting::Actions::PendingPost.call(
        hub: Account.find_by!(name: 'hub_pending'),
        user: user.accounts.find_by!(name: "##{user_id}_user_pending"),
        amount: price,
        object: self
      )
    end

    def change_accrued
      Accounting::Actions::AccruedPost.call(
        hub: Account.find_by!(name: 'hub_accrued'),
        user: user.accounts.find_by!(name: "##{user_id}_user_accrued"),
        amount: -price_before_last_save,
        object: self
      )

      Accounting::Actions::AccruedPost.call(
        hub: Account.find_by!(name: 'hub_accrued'),
        user: user.accounts.find_by!(name: "##{user_id}_user_accrued"),
        amount: price,
        object: self
      )
    end

    def pending_to_accrued
      group = TransactionGroup.create!(
        kind: 'pending_to_accrued',
        object: self
      )

      Accounting::Actions::PendingPost.call(
        hub: Account.find_by!(name: 'hub_pending'),
        user: user.accounts.find_by!(name: "##{user_id}_user_pending"),
        amount: -price_before_last_save,
        group: group
      )

      Accounting::Actions::AccruedPost.call(
        hub: Account.find_by!(name: 'hub_accrued'),
        user: user.accounts.find_by!(name: "##{user.id}_user_accrued"),
        amount: price,
        group: group
      )
    end

    def accrued_to_pending(kind)
      group = TransactionGroup.create!(
        kind: kind,
        object: self
      )

      Accounting::Actions::AccruedPost.call(
        hub: Account.find_by!(name: 'hub_accrued'),
        user: user.accounts.find_by!(name: "##{user.id}_user_accrued"),
        amount: -price_before_last_save,
        object: self,
        group: group
      )

      Accounting::Actions::PendingPost.call(
        hub: Account.find_by!(name: 'hub_pending'),
        user: user.accounts.find_by!(name: "##{user_id}_user_pending"),
        amount: price,
        object: self,
        group: group
      )
    end
  end
end
