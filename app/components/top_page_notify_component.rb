# frozen_string_literal: true

class TopPageNotifyComponent < ViewComponent::Base
  def initialize(message:, alert_type:)
    super
    @alert_type = alert_type
    @message = message
  end

  def render?
    @message.present?
  end
end
