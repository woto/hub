# frozen_string_literal: true

module Accounting
  module Actions
    class FundToAdvegoAccountUsd
      class Contract < Dry::Validation::Contract
        params do
          required(:fund_payed).value(type?: Account)
          required(:advego_convertor_rub).value(type?: Account)
          required(:advego_convertor_usd).value(type?: Account)
          required(:advego_account_usd).value(type?: Account)
          required(:amount_in_rub).value(type?: Integer).value(excluded_from?: [0])
          required(:amount_in_usd).value(type?: Integer).value(excluded_from?: [0])
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

      # Из фонда на аккаунт адвего
      def call
        Accounting::CreateTransaction.call(
          credit: context.fund_payed,
          debit: context.advego_convertor_rub,
          group: @group,
          amount: context.amount_in_rub
        )

        Accounting::CreateTransaction.call(
          credit: context.advego_convertor_usd,
          debit: context.advego_account_usd,
          group: @group,
          amount: context.amount_in_usd
        )
      end
    end
  end
end
