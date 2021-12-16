# frozen_string_literal: true

module Topicable
  extend ActiveSupport::Concern

  included do
    def topics_attributes=(titles)
      topics = []

      titles.each do |title|
        # TODO: write article
        # If remove this line then you could not pass topic with empty title.
        # The exception ActiveRecord::RecordInvalid will be raised
        next if title.blank?

        topics << Topic.find_or_create_by(title: title)
      end

      self.topics = topics
    end
  end
end
