# frozen_string_literal: true

module Accounting
  class CreateTransaction
    include ApplicationInteractor
    include AfterCommitEverywhere

    contract do
      params do
        config.validate_keys = true
        required(:credit).value(type?: Account)
        required(:debit).value(type?: Account)
        required(:group).value(type?: TransactionGroup)
        required(:amount).value(type?: BigDecimal)
        optional(:obj)
      end

      rule(:credit, :debit) do
        if [values[:credit].code, values[:debit].code].compact.uniq.size > 1
          key.failure('must have same codes')
        end
      end

      rule(:credit, :debit, :obj) do
        if [values[:credit].currency, values[:debit].currency, values[:obj]&.currency].compact.uniq.size > 1
          key.failure('must have same currencies')
        end
      end

      rule(:amount) do
        key.failure('must be equal or greater than 0') if value.negative?
      end
    end

    def call
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
