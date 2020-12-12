# frozen_string_literal: true

class PostDecorator < ApplicationDecorator
  def status
    h.render PostStatusComponent.new(status: super)
  end

  def price
    decorate_money(super, currency)
  end

  def title
    h.link_to(h.truncate(super), h.post_path(_id))
  end

  def body
    h.truncate(h.strip_tags(super))
  end
end
