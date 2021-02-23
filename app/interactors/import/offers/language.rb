module Import
  module Offers
    class Language
      LANGUAGE_KEY = "detected_language"
      LANGUAGE_UNKNOWN = { name: 'UNKNOWN', code: 'un', reliable: false }.freeze

      def self.call(offer)
        offer[LANGUAGE_KEY] = LANGUAGE_UNKNOWN
        string = offer.values_at('name', 'description').flatten.compact
                      .map { |el| el[Feeds::Offers::HASH_BANG_KEY] }.join(' - ')
        offer[LANGUAGE_KEY] = CLD.detect_language(string)
      end
    end
  end
end
