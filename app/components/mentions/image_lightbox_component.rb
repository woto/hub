# frozen_string_literal: true

class Mentions::ImageLightboxComponent < ViewComponent::Base
  def initialize(id:, thumbnails:, original:, width:, height:, class:, size:)
    super
    @thumbnails = thumbnails
    @original = original
    @width = width
    @height = height
    @class = binding.local_variable_get(:class)
    @size = size
  end
end
