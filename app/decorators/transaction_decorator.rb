# frozen_string_literal: true

class TransactionDecorator < ApplicationDecorator
  def amount
    decorate_money(super, currency)
  end

  def debit_amount
    decorate_money(super, currency)
  end

  def credit_amount
    decorate_money(super, currency)
  end
end
