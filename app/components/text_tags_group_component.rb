# frozen_string_literal: true

class TextTagsGroupComponent < ViewComponent::Base
  def initialize(text_tags_group:, text_color:, bg_color:)
    super
    @text_tags_group = text_tags_group
    @text_color = text_color
    @bg_color = bg_color
  end
end
