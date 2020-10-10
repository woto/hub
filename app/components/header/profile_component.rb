# frozen_string_literal: true

class Header::ProfileComponent < ViewComponent::Base
  def initialize(capybara_browser:, current_user:, true_user:)
    @capybara_browser = capybara_browser
    @current_user = current_user
    @true_user = true_user
  end
end
