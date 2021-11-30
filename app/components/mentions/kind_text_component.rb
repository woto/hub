# frozen_string_literal: true

class Mentions::KindTextComponent < ViewComponent::Base
  def initialize(kind_text:)
    @kind_text = kind_text
  end

  def render?
    @kind_text.present?
  end
end
