class Left::Menu::Dropdown::ItemComponent < ViewComponent::Base
  def initialize(title:, path:, current_page:, disabled:)
    @title = title
    @path = path
    @current_page = current_page
    @disabled = disabled
  end
end
