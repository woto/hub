# frozen_string_literal: true

class AccountDecorator < ApplicationDecorator
  def amount
    decorate_money(super, currency)
  end
end
