# frozen_string_literal: true

class MentionDecorator < ApplicationDecorator
  def status
    h.badge(status: super)
  end

  def url
    truncated = h.truncate(super, length: 40)
    link_options = { 'data-turbo' => 'false', rel: [Seo::NoReferrer, Seo::NoFollow, Seo::UGC] }
    if truncated != super
      link_options['data-bs-toggle'] = 'tooltip'
      link_options['title'] = super
    end
    h.link_to(truncated, super, **link_options)
  end

  def image
    h.render Mentions::ImageLightboxComponent.new(
      **super.symbolize_keys,
      class: 'responsive-image img-thumbnail bg-white',
      size: '200'
    )
  end

  def title
    h.tag.span super, class: 'strong responsive-title'
  end

  def topics
    h.render(TextTagComponent.with_collection(super))
  end

  def entities
    h.render(Mentions::EntityComponent.with_collection(super))
  end

  def published_at
    decorate_datetime(super)
  end
end
