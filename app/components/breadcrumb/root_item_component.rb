# frozen_string_literal: true

class Breadcrumb::RootItemComponent < ViewComponent::Base
  def initialize(title:, url:)
    @title = title
    @url = url
  end

end
