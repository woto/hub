# frozen_string_literal: true

module Entities
  class RelatedQuery
    include ApplicationInteractor

    contract do
      params do
        optional(:mentions_search_string)
        optional(:entities_search_string)
        optional(:entity_ids)
        required(:size)
      end
    end

    def call
      body = Jbuilder.new do |json|
        json.query do
          json.bool do
            json.filter do
              if context.mentions_search_string.present?
                json.array! ['fuck'] do
                  json.query_string do
                    json.query context.mentions_search_string
                  end
                end
              end

              if context.entity_ids.present?
                context.entity_ids.each do |entity_id|
                  json.array! ['fuck'] do
                    json.nested do
                      json.path 'entities'
                      json.query do
                        json.term do
                          json.set! 'entities.entity_id', entity_id
                        end
                      end
                      # json.terms_set do
                      #   json.set! "entities.entity_id" do
                      #     json.terms context.entity_ids
                      #     json.minimum_should_match_script do
                      #       json.source (context.entity_ids.size).to_s
                      #     end
                      #     json.boost 1.0
                      #   end
                      # end
                    end
                  end
                end
              end
            end
          end
        end

        json.aggs do
          json.group do
            json.nested do
              json.path 'entities'
            end
            json.aggs do
              json.group do
                json.filter do
                  json.bool do
                    json.filter do
                      if context.entities_search_string.present?
                        # json.array! ['fuck!'] do
                        #   json.match do
                        #     json.set! "entities.title", context.entities_search_string
                        #   end
                        # end

                        json.array! ['fuck!'] do
                          json.multi_match do
                            json.query context.entities_search_string
                            json.type 'bool_prefix'
                            json.fields %w[
                              entities.title.autocomplete
                              entities.title.autocomplete._2gram
                              entities.title.autocomplete._3gram
                            ]
                          end
                        end
                      end

                      json.array! ['fuck!'] do
                        json.match_all
                      end
                    end
                  end
                end

                json.aggs do
                  json.group do
                    json.terms do
                      json.field 'entities.entity_id'
                      json.size context.size
                    end
                  end
                end
              end
            end
          end
        end
      end

      context.object = {}.tap do |h|
        h[:body] = body.attributes!.deep_symbolize_keys
        h[:index] = Elastic::IndexName.pick('mentions').scoped
        h[:size] = 0
        h[:from] = 0
        h[:_source] = context._source
      end
    end
  end
end
