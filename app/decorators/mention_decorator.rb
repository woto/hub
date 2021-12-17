# frozen_string_literal: true

class MentionDecorator < ApplicationDecorator
  def status
    h.badge(status: super)
  end

  def url
    truncated = h.truncate(super, length: 40)
    link_options = { 'data-turbo' => 'false', rel: Seo::NoReferrer }
    if truncated != super
      link_options['data-bs-toggle'] = 'tooltip'
      link_options['title'] = super
    end
    h.link_to(truncated, super, **link_options)
  end

  def image
    h.render Mentions::ImageLightboxComponent.new(
      **super.symbolize_keys,
      class: 'img-thumbnail bg-white',
      size: '100'
    )
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

  def kinds
    h.render Mentions::KindTextComponent.with_collection(super)
  end

  def sentiments
    h.render(Mentions::SentimentTextComponent.with_collection(super))
  end
end
