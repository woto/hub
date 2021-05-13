# frozen_string_literal: true

class AccountDecorator < ApplicationDecorator
  def amount
    h.tag.mark do
      decorate_money(super, currency)
    end
  end

  def code
    h.render PostStatusComponent.new(status: super)
  end
end
