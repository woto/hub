class EntityDecorator < ApplicationDecorator
  def image
    h.render Mentions::ImageLightboxComponent.new(**super.symbolize_keys,
                                                  class: 'responsive-image bg-white img-thumbnail',
                                                  size: '100')
  end

  def lookups
    h.render(TextTagComponent.with_collection(super, color: 'azure'))
  end

  def topics
    h.render(TextTagComponent.with_collection(super))
  end

  def intro
    h.tag.span super, class: 'responsive-title'
  end

  def title
    h.tag.span super, class: 'strong responsive-title'
  end
end
