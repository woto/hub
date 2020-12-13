# frozen_string_literal: true

class Header::LanguageComponent < ViewComponent::Base
  def initialize(display_title:, capybara_browser: nil)
    @display_title = display_title
  end
end
