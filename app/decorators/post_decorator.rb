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
    h.tag.span(h.link_to(truncated, h.post_path(_id), **link_options), class: 'tw-text-lg 2xl:tw-text-sm')
  end

  def intro
    decorate_text(h.strip_tags(super))
  end

  def body
    decorate_text(h.strip_tags(super))
  end

  def tags
    h.render(TextTagComponent.with_collection(super, text_color: 'tw-text-blue-800', bg_color: 'tw-bg-blue-100'))
  end

  def published_at
    h.render TimeAgoComponent.new(datetime: super)
  end
end
