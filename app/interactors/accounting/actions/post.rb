# frozen_string_literal: true

module Accounting
  module Actions
    class Post
      include ApplicationInteractor

      contract do
        params do
          config.validate_keys = true
          required(:from).value(type?: Account)
          required(:to).value(type?: Account)
          required(:amount).value(type?: BigDecimal)
          required(:obj).value(type?: ::Post)
          required(:group).value(type?: TransactionGroup)
        end
      end

      def call
        Accounting::CreateTransaction.call(
          credit: context.from,
          debit: context.to,
          group: context.group,
          amount: context.amount,
          obj: context.obj
        )
      end
    end
  end
end
