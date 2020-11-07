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
        required(:amount).value(type?: Integer).value(excluded_from?: [0])
      end

      rule(:credit, :debit) do
        key.failure('must have same code') if values[:credit].code != values[:debit].code
      end

      rule(:credit, :debit) do
        key.failure('must have same currency') if values[:credit].currency != values[:debit].currency
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
        amount: context.amount
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
      ActiveRecord::Relation::QueryAttribute.new('amount', amount, ActiveRecord::Type::Integer.new)
    end
  end
end
