# frozen_string_literal: true

module Mentions
  class ScrapperJob < ApplicationJob
    queue_as :low
    unique :until_executing, on_conflict: :log

    def perform(mention_id:, mention_url:, user_id:)
      result = Extractors::Metadata::Scrapper.call(url: mention_url)

      if result.success?
        object = result.object

        mention = Mention.find(mention_id)

        ActiveRecord::Base.transaction do
          base64 = object['image']
          image = Image.create!(image_data_uri: base64, user_id:)
          ImagesRelation.create!(image:, relation: mention, user_id:)
        end

        mention.__elasticsearch__.index_document
        mention.class.__elasticsearch__.refresh_index!
      else
        raise result.message
      end
    end
  end
end
