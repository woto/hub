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
    h.tag.span(h.link_to(truncated, h.post_path(_id), **link_options), class: 'responsive-title')
  end

  def intro
    decorate_text(h.strip_tags(super))
  end

  def body
    decorate_text(h.strip_tags(super))
  end

  def tags
    h.render(ReactComponent.new(name: 'MultipleTags',
                                class: '',
                                props: {
                                  tags: super.compact_blank.map { |topic| { title: topic } },
                                  textColor: 'tw-text-blue-800',
                                  bgColor: 'tw-bg-blue-100'
                                }))
  end

  def published_at
    decorate_datetime(super)
  end
end
