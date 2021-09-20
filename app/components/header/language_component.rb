# frozen_string_literal: true

module Header
  class LanguageComponent < ViewComponent::Base
    def initialize(capybara_browser: nil)
    end

    def render?
      return true unless Current.realm

      Current.realm.news? || Current.realm.help?
    end
  end
end
