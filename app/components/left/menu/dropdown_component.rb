# frozen_string_literal: true

class Left::Menu::DropdownComponent < ViewComponent::Base
  renders_one :items
  def initialize(title:, current_page:, icon:, disabled:)
    @title = title
    @current_page = current_page
    @icon = icon
    @disabled = disabled
  end
end
