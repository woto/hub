# frozen_string_literal: true

module Mentions
  class ScrapperJob < ApplicationJob
    queue_as :low
    unique :until_executing, on_conflict: :log

    def perform(mention_id:, mention_url:, user_id:)
      result = Extractors::Metadata::Scrapper.call(url: mention_url)

      if result.success?
        object = result.object

        ActiveRecord::Base.transaction do
          image = Image.create!(image_data_uri: object['image'], user_id: user_id)
          ImagesRelation.create!(image: image, relation_id: mention_id, relation_type: 'Mention', user_id: user_id)
        end

        mention = Mention.find(mention_id)
        mention.__elasticsearch__.index_document
        mention.class.__elasticsearch__.refresh_index!
      else
        raise result.message
      end
    end
  end
end
