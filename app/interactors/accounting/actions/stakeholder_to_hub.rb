# frozen_string_literal: true

module Accounting
  module Actions
    class StakeholderToHub
      class Contract < Dry::Validation::Contract
        params do
          required(:stakeholder_payed).value(type?: Account)
          required(:hub_payed).value(type?: Account)
          required(:amount).value(type?: BigDecimal).value(excluded_from?: [0])
          optional(:group).value(type?: TransactionGroup)
        end
      end

      include ApplicationInteractor

      before do
        contract = Contract.new.call(context.to_h)
        raise StandardError, contract.errors.to_h if contract.failure?
      end

      # Предполагается что акционер выделил средства в общак наличными
      def call
        Accounting::CreateTransaction.call(
          credit: context.stakeholder_payed,
          debit: context.hub_payed,
          group: context.group,
          amount: context.amount,
          obj: context.obj
        )
      end
    end
  end
end
