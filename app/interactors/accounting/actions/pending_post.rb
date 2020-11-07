# frozen_string_literal: true

module Accounting
  module Actions
    class PendingPost
      class Contract < Dry::Validation::Contract
        params do
          required(:hub).value(type?: Account)
          required(:user).value(type?: Account)
          required(:amount).value(type?: Integer).value(excluded_from?: [0])
          optional(:object).maybe(type?: Post)
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
      # Предполагается, что я выплачу эти деньги, когда статью заапрувят
      def call
        # Новые счета
        Accounting::CreateTransaction.call(
          credit: context.hub,
          debit: context.user,
          group: @group,
          amount: context.amount
        )
      end
    end
  end
end
