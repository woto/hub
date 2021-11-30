# frozen_string_literal: true

class AccordionBodyComponent < ViewComponent::Base
  def initialize(css_class:)
    super
    @css_class = css_class
  end
end
