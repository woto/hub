# frozen_string_literal: true

module Accounting
  module Actions
    class StakeholderToFund
      class Contract < Dry::Validation::Contract
        params do
          required(:stakeholder_payed).value(type?: Account)
          required(:fund_payed).value(type?: Account)
          required(:amount).value(type?: Integer).value(excluded_from?: [0])
          optional(:group).maybe(type?: TransactionGroup)
        end
      end

      include ApplicationInteractor

      before do
        contract = Contract.new.call(context.to_h)
        raise StandardError, contract.errors.to_h if contract.failure?

        @group = context.group || TransactionGroup.create!(
          kind: self.class.name.demodulize.underscore,
          object: context.object
        )
      end

      # Предполагается что акционер выделил средства в общак наличными
      def call
        Accounting::CreateTransaction.call(
          credit: context.stakeholder_payed,
          debit: context.fund_payed,
          group: @group,
          amount: context.amount
        )
      end
    end
  end
end
