# frozen_string_literal: true

class NavbarFavoriteComponent < ViewComponent::Base
  def initialize(display_title:)
    super
    @display_title = display_title
  end
end
