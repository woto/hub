# frozen_string_literal: true

module Offers
  class Language
    include ApplicationInteractor
    delegate :json, to: :context

    contract do
      params do
        config.validate_keys = true
        required(:json)
        required(:languages).maybe { array? { each { string? } } }
      end
    end

    def call
      context.object = _filter
    end

    private

    def _filter
      if context.languages.to_a.any?(&:present?)
        json.set! :filter do
          json.array! ['fuck'] do
            json.terms do
              json.set! 'detected_language.code', context.languages
            end
          end
        end
      end
    end
  end
end
