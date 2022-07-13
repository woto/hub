# frozen_string_literal: true

class Breadcrumb::ItemComponent < ViewComponent::Base
  def initialize(title:, url:)
    @title = title
    @url = url
  end

end
