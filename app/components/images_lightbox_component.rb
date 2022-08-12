# frozen_string_literal: true

class ImagesLightboxComponent < ViewComponent::Base
  def initialize(images:, class:, size:)
    super
    @images = images
    @class = binding.local_variable_get(:class)
    @size = size
  end
end
