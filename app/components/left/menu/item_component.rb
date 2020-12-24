# frozen_string_literal: true

class Left::Menu::ItemComponent < ViewComponent::Base
  def initialize(path:, current_page:, title:, icon:, disabled:)
    @path = path
    @current_page = current_page
    @title = title
    @icon = icon
    @disabled = disabled
  end
end