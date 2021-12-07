# frozen_string_literal: true

class Mentions::ImageLightboxComponent < ViewComponent::Base
  def initialize(image_thumbnail:, image_original:, image_width:, image_height:, image_class:)
    @image_thumbnail = image_thumbnail
    @image_original = image_original
    @image_width = image_width
    @image_height = image_height
    @image_class = image_class
  end
end
