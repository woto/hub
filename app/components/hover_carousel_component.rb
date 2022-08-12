# frozen_string_literal: true

class HoverCarouselComponent < ViewComponent::Base
  def initialize(images:, class:, size:)
    @images = images
    @class = binding.local_variable_get(:class)
    @size = size
  end
end
