# frozen_string_literal: true

module Mentions
  class IframelyJob < ApplicationJob
    queue_as :low
    unique :until_executing, on_conflict: :log

    def perform(mention_id:, mention_url:)
      result = Extractors::Metadata::IframelyInteractor.call(url: mention_url)

      if result.success?
        object = result.object

        mention = ActiveRecord::Base.transaction do
          Mention.update(
            mention_id,
            canonical_url: object.dig('meta', 'canonical'),
            title: object.dig('meta', 'title')
          )
        end

        mention.__elasticsearch__.index_document
        mention.class.__elasticsearch__.refresh_index!
      else
        raise result.message
      end
    end
  end
end
