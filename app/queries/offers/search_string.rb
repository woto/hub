# frozen_string_literal: true

module Offers
  class SearchString
    include ApplicationInteractor
    delegate :json, to: :context

    contract do
      params do
        config.validate_keys = true
        required(:json)
        required(:q).maybe(:string)
      end
    end

    def call
      context.object = _search_string
    end

    private

    def _search_string
      if context.q.present?
        tokens = Elastic::TokenizeInteractor.call(q: context.q).object
        string = tokens.join(' ')
      end

      if string.present?
        json.set! :should do
          json.array! ['fuck'] do
            json.multi_match do
              json.query string
              json.fields %W[
                name.#{Import::Offers::HashifyInteractor::HASH_BANG_KEY}^30
                feed_category_name
                description.#{Import::Offers::HashifyInteractor::HASH_BANG_KEY}
              ]
            end
          end
        end

        json.set! :filter do
          json.array! ['fuck'] do
            json.multi_match do
              json.query string
              json.fields %W[
                name.#{Import::Offers::HashifyInteractor::HASH_BANG_KEY}
                feed_category_name
                description.#{Import::Offers::HashifyInteractor::HASH_BANG_KEY}
              ]
              json.fuzziness 'auto'
              json.minimum_should_match tokens.count
            end
          end
        end
      else
        # json.set! :filter do
        #   json.array! ['fuck'] do
        #     json.match_all
        #   end
        # end
      end
    end
  end
end
