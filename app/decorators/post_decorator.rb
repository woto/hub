# frozen_string_literal: true

class PostDecorator < ApplicationDecorator
  def status
    h.render PostStatusComponent.new(status: super)
  end

  def price
    decorate_money(super, currency)
  end

  def title
    truncated = h.truncate(super, length: 50)
    tooltip_options = if truncated != super
       { data: {"bs-toggle": "tooltip"}, title: super }
    else
      {}
    end
    h.link_to(truncated, h.post_path(_id), **tooltip_options)
  end

  def body
    h.truncate(h.strip_tags(super))
  end

  def published_at
    decorate_datetime(super)
  end
end
