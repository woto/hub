# frozen_string_literal: true

module Accounting
  module Actions
    class Contract < Dry::Validation::Contract
      params do
        required(:hub_accrued).value(type?: Account)
        required(:user_accrued).value(type?: Account)
        required(:hub_payed).value(type?: Account)
        required(:yandex_payed).value(type?: Account)
        required(:yandex_commission).value(type?: Account)
        required(:amount).value(type?: BigDecimal).value(excluded_from?: [0])
        optional(:group).value(type?: TransactionGroup)
      end
    end

    class AccruedToPaidWithYandex
      include ApplicationInteractor

      before do
        contract = Contract.new.call(context.to_h)
        raise StandardError, contract.errors.to_h if contract.failure?
      end

      # Я сделал перевод пользователю через Яндекс деньги
      def call
        # Старые счета
        Accounting::CreateTransaction.call(
          credit: context.hub_accrued,
          debit: context.user_accrued,
          group: context.group,
          amount: -context.amount
        )

        # Допустим комиссия Яндекса за перевод 5% от суммы перевода.
        amount_with_commission = (context.amount * (1 + 0.05))

        # # Допустим комиссия Яндекса за перевод 5% к сумме перевода.
        # amount_with_commission = (context.amount / (1 - 0.05))

        # Новые счета
        Accounting::CreateTransaction.call(
          credit: context.hub_payed,
          debit: context.yandex_payed,
          group: context.group,
          amount: amount_with_commission
        )

        # Яндекс взял комиссию за перевод
        Accounting::CreateTransaction.call(
          credit: context.yandex_payed,
          debit: context.yandex_commission,
          group: context.group,
          amount: amount_with_commission - context.amount
        )

        # Яндекс перевел мои деньги на располагаемый пользователем счет
        Accounting::CreateTransaction.call(
          credit: context.yandex_payed,
          debit: context.user_payed,
          group: context.group,
          amount: context.amount
        )
      end
    end
  end
end
