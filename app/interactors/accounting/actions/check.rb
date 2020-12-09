# frozen_string_literal: true

module Accounting
  module Actions
    class Check
      class Contract < Dry::Validation::Contract
        params do
          required(:hub).value(type?: Account)
          required(:user).value(type?: Account)
          required(:amount).value(type?: BigDecimal).value(excluded_from?: [0])
          required(:obj).value(type?: ::Check)
          optional(:group).value(type?: TransactionGroup)
        end
      end

      include ApplicationInteractor

      before do
        contract = Contract.new.call(context.to_h)
        raise StandardError, contract.errors.to_h if contract.failure?
      end

      def call
        Accounting::CreateTransaction.call(
          credit: context.hub,
          debit: context.user,
          group: context.group,
          amount: context.amount,
          obj: context.obj
        )
      end
    end
  end
end
