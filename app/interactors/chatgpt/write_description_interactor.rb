# frozen_string_literal: true

module Chatgpt
  class WriteDescriptionInteractor
    include ApplicationInteractor

    PROMPT = <<~HERE.squish
      I want you act as a SEO copywriter.
      I will provide you a product title and links to the product photos.
      The response must be in Russian language.
    HERE

    def call
      OpenAI.configure do |config|
        config.access_token = ENV.fetch('OPENAI_ACCESS_TOKEN')
      end

      query = Offers::RandomQuery.call.object

      result = GlobalHelper.elastic_client.search(query).then do |res|
        pp res
      end
    end
  end
end
