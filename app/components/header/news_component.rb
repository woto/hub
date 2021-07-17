# frozen_string_literal: true

module Header
  class NewsComponent < ViewComponent::Base
    def initialize(locale)
      super
      @realm = Realm.news.find_by!(locale: locale)
    end
  end
end
