# frozen_string_literal: true

class TimeAgoComponent < ViewComponent::Base
  def initialize(datetime:)
    @datetime = datetime
    @datetime = Time.zone.parse(datetime) if datetime.is_a?(String)
  end

  def render?
    !@datetime.nil?
  end
end