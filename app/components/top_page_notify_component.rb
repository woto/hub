class TopPageNotifyComponent < ViewComponent::Base
  def initialize(message:, alert_type:)
    # TODO: limit types
    @alert_type = alert_type
    @message = message
  end

  def render?
    !@message.nil?
  end
end
