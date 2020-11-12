# frozen_string_literal: true

class PostDecorator < ApplicationDecorator

  def status
    h.render Decorators::Post::StatusComponent.new(status: object.status)
  end

  def price
    h.number_to_currency(object.price)
  end

  def title
    h.link_to(h.truncate(object.title), h.post_path(object.id))
  end

  def body
    h.truncate(h.strip_tags(object.body))
  end
end
