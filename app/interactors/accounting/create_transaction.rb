# frozen_string_literal: true

module Accounting
  class CreateTransaction
    include ApplicationInteractor
    include AfterCommitEverywhere

    class Contract < Dry::Validation::Contract
      params do
        required(:debit).value(type?: Account)
        required(:credit).value(type?: Account)
        required(:group).value(type?: TransactionGroup)
        required(:amount).value(type?: BigDecimal)
        optional(:obj)
      end

      rule(:credit, :debit) do
        key.failure('must have same code') if values[:credit].code != values[:debit].code
      end

      rule(:credit, :debit) do
        key.failure('must have same currency') if values[:credit].currency != values[:debit].currency
      end

      rule(:amount) do
        key.failure('must be equal or greater than 0.01') unless value.abs >= 0.01
      end

      rule(:obj) do
        if values[:obj]
          if values[:obj].currency != values[:credit].currency
            key.failure('obj.currency and credit.currency must be equal')
          end
          if values[:obj].currency != values[:debit].currency
            key.failure('obj.currency and debit.currency must be equal')
          end
        end
      end

    end

    def call
      contract = Contract.new.call(context.to_h)
      raise StandardError, contract.errors.to_h if contract.failure?

      amount = context.amount

      credit_amount = update_balance(context.credit.id, -amount)
      debit_amount = update_balance(context.debit.id, amount)

      Transaction.create!(
        credit: context.credit, credit_amount: credit_amount,
        debit: context.debit, debit_amount: debit_amount,
        transaction_group: context.group,
        amount: context.amount,
        obj: context.obj,
        responsible: Current.responsible
      )

      after_commit do
        ids = [context.credit.id, context.debit.id]
        Account.__elasticsearch__.import query: -> { Account.where(id: [ids]) }
      end
    end

    private

    def update_balance(id, amount)
      sql = 'UPDATE "accounts" SET "amount" = "amount" + $1 WHERE "id" = $2 RETURNING "amount"'
      binds = [bind_amount(amount), bind_id(id)]
      ActiveRecord::Base.connection.exec_query(sql, 'sql', binds)[0]['amount']
    end

    def bind_id(id)
      ActiveRecord::Relation::QueryAttribute.new('id', id, ActiveRecord::Type::BigInteger.new)
    end

    def bind_amount(amount)
      ActiveRecord::Relation::QueryAttribute.new('amount', amount, ActiveRecord::Type::Decimal.new)
    end
  end
end
