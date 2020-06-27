class Left::Menu::DropdownComponent < ViewComponent::Base
  with_content_areas :items
  def initialize(title:, current_page:, icon:, disabled:)
    @title = title
    @current_page = current_page
    @icon = icon
    @disabled = disabled
  end
end
