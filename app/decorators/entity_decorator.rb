class EntityDecorator < ApplicationDecorator
  def image
    h.render Mentions::ImageLightboxComponent.new(**super.symbolize_keys,
                                                  class: 'responsive-image bg-white img-thumbnail',
                                                  size: '100')
  end

  def lookups
    h.render(ReactComponent.new(name: 'MultipleTags',
                                class: '',
                                props: {
                                  tags: super.compact_blank,
                                  textColor: 'tw-text-pink-800',
                                  bgColor: 'tw-bg-pink-100'
                                }))
  end

  def topics
    h.render(ReactComponent.new(name: 'MultipleTags',
                                class: '',
                                props: {
                                  tags: super.compact_blank,
                                  textColor: 'tw-text-blue-800',
                                  bgColor: 'tw-bg-blue-100'
                                }))
  end

  def intro
    h.tag.span super, class: 'responsive-title'
  end

  def title
    h.tag.span super, class: 'strong responsive-title'
  end
end
