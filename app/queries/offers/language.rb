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
      codes = context.languages&.compact_blank
      if codes.present?
        codes_array = codes.map { |code| "'#{code}'" }.join(', ')
        feed_ids = Feed.where(%(languages ?| array[#{codes_array}])).pluck(:id)
        json.set! :filter do
          json.array! ['fuck'] do
            json.terms do
              json.set! 'feed_id', feed_ids
            end
          end
        end
      end
    end
  end
end
