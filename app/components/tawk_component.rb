class TawkComponent < ViewComponent::Base
  def render?
    ENV['TAWK_ENABLED'] == 'true'
  end
end
