class MentionDecorator < ApplicationDecorator
  def status
    h.badge(status: super)
  end

  def url
    truncated = h.truncate(super, length: 40)
    link_options = { 'data-turbo' => 'false', rel: 'noreferrer' }
    if truncated != super
      link_options['data-bs-toggle'] = 'tooltip'
      link_options['title'] = super
    end
    h.link_to(truncated, super, **link_options)
  end

  def image
    h.link_to h.mention_path(_id) do
      h.image_tag super, class: 'max-height-100 img-thumbnail' if super
    end
  end

  def tags
    h.tags(super)
  end

  def entities
    h.tags(super)
  end

  def published_at
    decorate_datetime(super)
  end
end
