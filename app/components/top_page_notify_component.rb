# frozen_string_literal: true

class TopPageNotifyComponent < ViewComponent::Base
  def initialize(message:, alert_type:)
    super
    # TODO: limit types
    @alert_type = alert_type
    @message = message
  end

  def render?
    # TODO: move ugly comparison with div block to simple_form
    !@message.nil? && @message != '<div></div>'
  end
end
