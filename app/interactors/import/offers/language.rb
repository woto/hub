# frozen_string_literal: true

module Import
  module Offers
    class Language
      LANGUAGE_KEY = 'detected_language'

      def self.call(offer)
        proc = ->(el) { el[Import::Offers::Hashify::HASH_BANG_KEY] }
        string = offer.values_at('name', 'description').flatten.compact.map(&proc).join(' - ')
        offer[LANGUAGE_KEY] = CLD.detect_language(string).stringify_keys
      end
    end
  end
end
