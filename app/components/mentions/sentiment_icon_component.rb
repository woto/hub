# frozen_string_literal: true

class Mentions::SentimentIconComponent < ViewComponent::Base
  def initialize(sentiment:)
    @sentiment = sentiment
  end

  def sentiment_to_icon
    lookup_table = {
      'positive' => 'fa-lg far fa-fw fa-thumbs-up',
      'unknown' => 'fa-lg far fa-fw fa-question-circle',
      'negative' => 'fa-lg far fa-fw fa-thumbs-down'
    }
    lookup_table.fetch(@sentiment)
  end
end
