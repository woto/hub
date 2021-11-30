# frozen_string_literal: true

class AccordionItemComponent < ViewComponent::Base
  renders_one :header
  renders_one :body, lambda { |css_class: ''|
    AccordionBodyComponent.new(css_class: css_class)
  }

  def initialize(accordion_id:, item_id:, css_class:)
    super
    @item_id = item_id
    @accordion_id = accordion_id
    @css_class = css_class
  end
end
