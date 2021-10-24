module Import
  module Offers
    class StandardAttributes
      ATTEMPT_UUID_KEY = 'attempt_uuid'
      INDEXED_AT_KEY = 'indexed_at'

      class << self
        def call(offer, feed)
          offer[ATTEMPT_UUID_KEY] = feed.attempt_uuid
          offer[INDEXED_AT_KEY] = Time.current
        end
      end
    end
  end
end

