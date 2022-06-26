# frozen_string_literal: true

module Mentions
  class ScrapperJob < ApplicationJob
    queue_as :low
    unique :until_executing, on_conflict: :log

    def perform(mention:, user:)
      result = Extractors::Metadata::Scrapper.call(url: mention.url)

      if result.success?
        object = result.object

        image = Image.create!(image_data_uri: object['image'], user: user)
        ImagesRelation.create!(image: image, relation: mention, user: user)

        mention.__elasticsearch__.send_document_to_elasticsearch
      else
        raise result.message
      end
    end
  end
end
