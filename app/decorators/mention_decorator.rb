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
    h.render ImagesLightboxComponent.new(
      images: super,
      class: 'responsive-image img-thumbnail bg-white',
      size: '200'
    )
  end

  def title
    h.tag.span super, class: 'strong tw-text-lg 2xl:tw-text-sm'
  end

  def topics
    h.render(TextTagsGroupComponent.new(text_tags_group: super))
  end

  def entities
    h.render( ReactComponent.new(name: 'Carousel', class: '', props: { items: super}))
    # h.render(EntitiesGroupComponent.new(entities_group: super))
  end

  def published_at
    h.render TimeAgoComponent.new(datetime: super)
  end
end
