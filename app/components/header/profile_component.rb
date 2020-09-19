# frozen_string_literal: true

class Header::ProfileComponent < ViewComponent::Base
  def initialize(capybara_browser:)
    @capybara_browser = capybara_browser
  end
end
