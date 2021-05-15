# frozen_string_literal: true

class AccountDecorator < ApplicationDecorator
  def amount
    h.tag.mark do
      decorate_money(super, currency)
    end
  end

  def code
    h.badge(status: super)
  end
end
