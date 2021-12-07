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
    h.render Mentions::ImageLightboxComponent.new(image_original: super['image_original'],
                                                  image_thumbnail: super['image_thumbnail'],
                                                  image_width: object['_source']['image']['width'],
                                                  image_height: object['_source']['image']['height'],
                                                  image_class: 'max-height-100 img-thumbnail')
  end

  def topics
    h.render(TextTagComponent.with_collection(super))
  end

  def entities
    h.render(Mentions::EntityComponent.with_collection(super.zip(object['_source']['entity_ids'])))
  end

  def published_at
    decorate_datetime(super)
  end

  def kinds
    h.render(Mentions::KindTextComponent.with_collection(super))
  end

  def sentiment
    h.render Mentions::SentimentTextComponent.new(sentiment_text: super)
  end
end
