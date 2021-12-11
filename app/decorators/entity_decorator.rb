class EntityDecorator < ApplicationDecorator
  def image
    options = { class: 'width-100 max-height-300 bg-white img-thumbnail' }
    if super.present?
      h.image_tag super, options
    else
      ApplicationController.helpers.image_pack_tag('media/images/icon-404-100.png', options)
    end
  end

  def lookups
    h.render(TextTagComponent.with_collection(super))
  end
end
