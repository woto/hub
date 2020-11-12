# frozen_string_literal: true

module Accounting
  module Actions
    class AdvertiserToBank
      class Contract < Dry::Validation::Contract
        params do
          required(:hub).value(type?: Account)
          required(:advertiser).value(type?: Account)
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

      # Рекламодатель перевел средства на расчетный счёт
      def call
        Accounting::CreateTransaction.call(
          credit: context.advertiser,
          debit: context.hub,
          group: @group,
          amount: context.amount
        )
      end
    end
  end
end
