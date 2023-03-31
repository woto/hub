# frozen_string_literal: true

module Chatgpt
  class WriteDescriptionInteractor
    include ApplicationInteractor

    PROMPT = <<~HERE.squish
      Write SEO description of the product in the language of origin:
    HERE

    def call
      OpenAI.configure do |config|
        config.access_token = ENV.fetch('OPENAI_ACCESS_TOKEN')
      end

      client = OpenAI::Client.new

      loop do
        query = Offers::RandomQuery.call.object

        offer = GlobalHelper.elastic_client.search(query)

        title = offer['hits']['hits'][0]['_source']['name'][0]['#']

        result = client.chat(
          parameters: {
            model: 'gpt-3.5-turbo',
            messages: [{ role: 'user', content: "#{PROMPT} #{title}" }],
            temperature: 0.7
          }
        )

        description = result['choices'][0]['message']['content']

        Description.create!(
          advertiser_id: offer['hits']['hits'][0]['_source']['advertiser_id'],
          feed_id: offer['hits']['hits'][0]['_source']['feed_id'],
          offer_id: offer['hits']['hits'][0]['_id'],
          title:,
          description:
        )
      rescue Net::ReadTimeout
        retry
      end
    end
  end
end
