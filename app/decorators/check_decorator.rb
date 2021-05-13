class CheckDecorator < ApplicationDecorator
  def status
    h.render PostStatusComponent.new(status: super)
  end

  def amount
    h.tag.mark do
      decorate_money(super, currency)
    end
  end

  def payed_at
    decorate_datetime(super)
  end
end
