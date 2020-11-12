# frozen_string_literal: true

class TawkComponent < ViewComponent::Base
  def render?
    ActiveModel::Type::Boolean.new.cast(ENV['TAWK_ENABLED'])
  end
end
