# frozen_string_literal: true

class AccordionComponent < ViewComponent::Base
  # renders_many :items, AccordionItemComponent

  renders_many :items, lambda { |item_id:, css_class: ''|
    AccordionItemComponent.new(accordion_id: @accordion_id, item_id: item_id, css_class: css_class)
  }

  def initialize(accordion_id:, css_class: '')
    super
    @accordion_id = accordion_id
    @css_class = css_class
  end
end
