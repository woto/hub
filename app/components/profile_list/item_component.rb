# frozen_string_literal: true

class ProfileList::ItemComponent < ViewComponent::Base
  def initialize(title:, path:, current_page:)
    @title = title
    @path = path
    @current_page = current_page
  end
end
