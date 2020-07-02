# frozen_string_literal: true

class Left::Menu::ItemComponent < ViewComponent::Base
  def initialize(path:, current_page:, title:, icon:)
    @path = path
    @current_page = current_page
    @title = title
    @icon = icon
  end
end
