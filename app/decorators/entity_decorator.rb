class EntityDecorator < ApplicationDecorator
  def title
    h.link_to object['_source']['title'], h.entity_path(_id)
  end

  def image
    h.link_to h.entity_path(_id) do
      options = { class: 'width-100 max-height-300 img-thumbnail' }
      if super.present?
        h.image_tag super, options
      else
        ApplicationController.helpers.image_pack_tag('media/images/icon-404-100.png', options)
      end
    end
  end

  def aliases
    h.render(TextTagComponent.with_collection(super))
  end
end
