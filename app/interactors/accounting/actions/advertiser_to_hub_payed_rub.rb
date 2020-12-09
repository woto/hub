# frozen_string_literal: true

module Accounting
  module Actions
    class AdvertiserToHubPayedRub
      class Contract < Dry::Validation::Contract
        params do
          required(:hub_payed_rub).value(type?: Account)
          required(:hub_bank_rub).value(type?: Account)
          required(:advertiser_rub).value(type?: Account)
          required(:amount).value(type?: BigDecimal).value(excluded_from?: [0])
          optional(:group).value(type?: TransactionGroup)
        end
      end

      include ApplicationInteractor

      before do
        contract = Contract.new.call(context.to_h)
        raise StandardError, contract.errors.to_h if contract.failure?
      end

      # Рекламодатель перевел средства на расчетный счёт
      def call
        Accounting::CreateTransaction.call(
          credit: context.advertiser_rub,
          debit: context.hub_bank_rub,
          group: context.group,
          amount: context.amount
        )

        Accounting::CreateTransaction.call(
          credit: context.hub_bank_rub,
          debit: context.hub_payed_rub,
          group: context.group,
          amount: context.amount
        )
      end
    end
  end
end
