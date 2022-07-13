# frozen_string_literal: true

class TitleComponent < ViewComponent::Base
  def initialize(title:)
    @title = title
  end
end
