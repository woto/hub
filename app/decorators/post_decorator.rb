# frozen_string_literal: true

class PostDecorator < ApplicationDecorator
  def status
    h.badge(status: super)
  end

  def amount
    h.tag.mark do
      decorate_money(super, currency)
    end
  end

  def title
    truncated = h.truncate(super, length: 50)
    link_options = { 'data-turbo' => 'false' }
    if truncated != super
      link_options['data-bs-toggle'] = 'tooltip'
      link_options['title'] = super
    end
    h.link_to(truncated, h.post_path(_id), **link_options)
  end

  def intro
    decorate_text(h.strip_tags(super))
  end

  def body
    decorate_text(h.strip_tags(super))
  end

  def tags
    h.render(TextTagComponent.with_collection(super))
  end

  def published_at
    decorate_datetime(super)
  end
end
