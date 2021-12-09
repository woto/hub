# frozen_string_literal: true

class Left::Menu::Dropdown::ItemComponent < ViewComponent::Base
  def initialize(title:, path:, current_page:, disabled:, options:)
    @title = title
    @path = path
    @current_page = current_page
    @disabled = disabled
    @options = options
  end
end
