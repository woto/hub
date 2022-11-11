# frozen_string_literal: true

class EntityDecorator < ApplicationDecorator
  def images
    h.render HoverCarouselComponent.new(images: super,
                                        class: 'tw-square tw-aspect-square tw-object-contain tw-bg-white tw-border tw-rounded tw-relative tw-p-1 tw-w-14 tw-rounded tw-rounded-lg tw-bg-no-repeat tw-bg-cover tw-bg-origin-border tw-bg-scroll tw-bg-center',
                                        size: '100')
    # h.render ImagesLightboxComponent.new(images: super,
    #                                      class: 'responsive-image bg-white img-thumbnail',
    #                                      size: '100')
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
    h.tag.span super, class: 'tw-text-lg 2xl:tw-text-sm'
  end

  def title
    h.tag.span super, class: 'strong tw-text-lg 2xl:tw-text-sm'
  end
end
