# frozen_string_literal: true

class PostCategoryDecorator < ApplicationDecorator
  def title
    truncated = h.truncate(super, length: 50)
    link_options = { 'data-turbo' => 'false' }
    if truncated != super
      link_options['data-bs-toggle'] = 'tooltip'
      link_options['title'] = super
    end
    if h.policy(:post_category).show?
      h.link_to(truncated, h.post_category_path(_id), **link_options)
    else
      h.link_to(truncated, '#', **link_options)
    end
  end

  def path
    h.content_tag :ul do
      super.map do |ancestor|
        h.concat(h.content_tag(:li, ancestor))
      end
    end
  end
end
