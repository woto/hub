# frozen_string_literal: true

module Accounting
  module Actions
    class Contract < Dry::Validation::Contract
      params do
        required(:hub_accrued).value(type?: Account)
        required(:user_accrued).value(type?: Account)
        required(:fund_payed).value(type?: Account)
        required(:yandex_payed).value(type?: Account)
        required(:yandex_commission).value(type?: Account)
        required(:amount).value(type?: Integer).value(excluded_from?: [0])
        optional(:group).maybe(type?: TransactionGroup)
      end
    end

    class AccruedToPaidWithYandex
      include ApplicationInteractor

      before do
        contract = Contract.new.call(context.to_h)
        raise StandardError, contract.errors.to_h if contract.failure?
        @group = context.group || TransactionGroup.create!(
            kind: self.class.name.demodulize.underscore,
            object: context.object
        )
      end

      # Я сделал перевод пользователю через Яндекс деньги
      def call
        # Старые счета
        Accounting::CreateTransaction.call(
          credit: context.hub_accrued,
          debit: context.user_accrued,
          group: @group,
          amount: -context.amount
        )

        # Допустим комиссия Яндекса за перевод 5% от суммы перевода.
        amount_with_commission = (context.amount * (1 + 0.05)).round

        # # Допустим комиссия Яндекса за перевод 5% к сумме перевода.
        # amount_with_commission = (context.amount / (1 - 0.05)).round

        # Новые счета
        Accounting::CreateTransaction.call(
          credit: context.fund_payed,
          debit: context.yandex_payed,
          group: @group,
          amount: amount_with_commission
        )

        # Яндекс взял комиссию за перевод
        Accounting::CreateTransaction.call(
          credit: context.yandex_payed,
          debit: context.yandex_commission,
          group: @group,
          amount: amount_with_commission - context.amount
        )

        # Яндекс перевел мои деньги на располагаемый пользователем счет
        Accounting::CreateTransaction.call(
          credit: context.yandex_payed,
          debit: context.user_payed,
          group: @group,
          amount: context.amount
        )
      end
    end
  end
end
