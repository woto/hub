# frozen_string_literal: true

# TODO: to test isolated for json query

module Tables
  class Favorites
    include ApplicationInteractor
    delegate :json, to: :context

    contract do
      params do
        # TODO: make it better?
        # config.validate_keys = true
        required(:json)
        required(:favorite_ids)
        required(:model)
      end
    end

    def call
      context.object = _filter
    end

    private

    def _filter
      if context.favorite_ids.present?
        json.array! ['fuck!'] do
          json.bool do
            json.filter do
              json.terms do
                json.id context.favorite_ids
              end
            end
          end
        end
      end
    end
  end
end