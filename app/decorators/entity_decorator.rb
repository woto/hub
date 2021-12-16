class EntityDecorator < ApplicationDecorator
  def image
    h.render Mentions::ImageLightboxComponent.new(**super.symbolize_keys,
                                                  class: 'bg-white img-thumbnail',
                                                  size: '50')
  end

  def lookups
    h.render(TextTagComponent.with_collection(super, color: 'azure'))
  end

  def topics
    h.render(TextTagComponent.with_collection(super))
  end
end
