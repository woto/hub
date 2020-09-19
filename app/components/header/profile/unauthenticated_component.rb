# frozen_string_literal: true

class Header::Profile::UnauthenticatedComponent < ViewComponent::Base
  def initialize(capybara_browser:)
    @capybara_browser = capybara_browser
  end
end
