# frozen_string_literal: true

class MentionComponent < ViewComponent::Base
  def initialize(mention:)
    @mention = mention
  end

end
