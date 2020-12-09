class CheckDecorator < ApplicationDecorator
  def amount
    decorate_money(super, currency)
  end

  def payed_at
    decorate_datetime(super)
  end
end
