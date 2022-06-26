# frozen_string_literal: true

module Mentions
  class IframelyJob < ApplicationJob
    queue_as :low
    unique :until_executing, on_conflict: :log

    def perform(mention:)
      result = Extractors::Metadata::Iframely.call(url: mention.url)

      if result.success?
        object = result.object

        mention.canonical_url = object.dig('meta', 'canonical')
        mention.title = object.dig('meta', 'title')
        mention.save!

        mention.__elasticsearch__.send_document_to_elasticsearch
      else
        raise result.message
      end
    end
  end
end
