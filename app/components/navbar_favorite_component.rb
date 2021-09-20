# frozen_string_literal: true

class NavbarFavoriteComponent < ViewComponent::Base
  def initialize()
    super
  end

  private

  def render?
    helpers.user_signed_in?
  end
end
