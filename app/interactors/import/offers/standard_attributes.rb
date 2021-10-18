module Import
  module Offers
    class StandardAttributes
      ATTEMPT_UUID_KEY = 'attempt_uuid'
      INDEXED_AT_KEY = 'indexed_at'

      class << self
        def call(offer, feed)
          offer[ATTEMPT_UUID_KEY] = feed.attempt_uuid
          offer[INDEXED_AT_KEY] = Time.current
          offer['description'] = sanitize(offer['description']) if offer['description']
        end

        private

        def sanitize(data)
          data.map do |obj|
            key = Import::Offers::Hashify::HASH_BANG_KEY
            obj[key] = Loofah.fragment(obj[key]).to_text(encode_special_chars: false).strip
            obj
          end
        end
      end
    end
  end
end

