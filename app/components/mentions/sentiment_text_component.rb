# frozen_string_literal: true

class Mentions::SentimentTextComponent < ViewComponent::Base
  def initialize(sentiment_text:)
    @sentiment_text = sentiment_text
  end

  private

  def render?
    @sentiment_text.present?
  end
end
