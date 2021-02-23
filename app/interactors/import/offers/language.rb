module Import
  module Offers
    class Language
      LANGUAGE_KEY = "detected_language"

      def self.call(offer)
        string = offer.values_at('name', 'description').flatten.compact
                      .map { |el| el[Feeds::Offers::HASH_BANG_KEY] }.join(' - ')
        offer[LANGUAGE_KEY] = CLD.detect_language(string).stringify_keys
      end
    end
  end
end
