# frozen_string_literal: true

module Header
  class UserComponent < ViewComponent::Base
    def initialize(user:)
      super
      @user = user
    end
  end
end
