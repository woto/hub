# frozen_string_literal: true

class TawkComponent < ViewComponent::Base
  def render?
    ENV['TAWK_ENABLED'] == 'true'
  end
end
