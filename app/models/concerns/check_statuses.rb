# frozen_string_literal: true

module CheckStatuses
  extend ActiveSupport::Concern

  included do
    def to_requested
      unless CheckStatusesPolicy.new(Current.responsible, self).to_requested?
        raise Pundit::NotAuthorizedError, "User with role `#{Current.responsible.role}` not allowed to Check#to_requested?"
      end

      case is_payed_before_last_save
      when nil
        request_check
      else
        raise "wrong is_payed transaction state: `#{is_payed_previous_change}`"
      end
    end

    def to_payed
      unless CheckStatusesPolicy.new(Current.responsible, self).to_payed?
        raise Pundit::NotAuthorizedError, "User with role `#{Current.responsible.role}` not allowed to Check#to_payed?"
      end

      case is_payed_before_last_save
      when false
        pay_check
      else
        raise "wrong is_payed transaction state: `#{is_payed_previous_change}`"
      end
    end
  end

  def request_check
    group = TransactionGroup.create!(
      kind: __method__
    )

    Accounting::Actions::Check.call(
      hub: Account.hub_requested_usd,
      user: Account.for_user_requested_usd(user),
      amount: amount,
      group: group,
      obj: self
    )
  end

  def pay_check
    group = TransactionGroup.create!(
      kind: __method__
    )

    Accounting::Actions::Check.call(
      hub: Account.hub_requested_usd,
      user: Account.for_user_requested_usd(user),
      amount: -amount_before_last_save,
      group: group,
      obj: self
    )

    Accounting::Actions::Check.call(
      hub: Account.hub_payed_usd,
      user: Account.for_user_payed_usd(user),
      amount: amount,
      group: group,
      obj: self
    )
  end
end
