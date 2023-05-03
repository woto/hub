# frozen_string_literal: true

module Mentions
  class IndexQuery
    include ApplicationInteractor

    contract do
      params do
        config.validate_keys = true

        required(:mentions_search_string)
        required(:optional_entity_ids).maybe { array? { each { integer? } } }
        required(:required_entity_ids).maybe { array? { each { integer? } } }
        optional(:mention_id).maybe(:int?)
        optional(:sort)
        optional(:order)
        optional(:from)
        optional(:size)
      end
    end

    def call
      body = Jbuilder.new do |json|
        json.query do
          if context.required_entity_ids.present? || context.optional_entity_ids.present?
            json.bool do
              json.filter do
                if context.mentions_search_string.present?
                  json.array! ['fuck!'] do
                    json.match do
                      json.set! 'title', context.mentions_search_string
                    end
                  end
                end

                if context.optional_entity_ids.present?
                  json.array! ['fuck!'] do
                    # NOTE: Any
                    json.nested do
                      json.path 'entities'
                      json.query do
                        json.array! ['fuck!'] do
                          json.terms do
                            json.set! 'entities.entity_id', context.optional_entity_ids
                          end
                        end
                      end
                    end
                  end
                end

                if context.required_entity_ids.present?
                  # NOTE: All
                  context.required_entity_ids.each do |entity_id|
                    json.array! ['fuck'] do
                      json.nested do
                        json.path 'entities'
                        json.query do
                          json.term do
                            json.set! 'entities.entity_id', entity_id
                          end
                        end
                      end
                    end
                  end
                end
              end

              if context.mention_id
                json.set! 'should' do
                  json.array! ['fuck'] do
                    json.term do
                      json.id do
                        json.value context.mention_id
                        json.boost 10
                      end
                    end
                  end
                end
              end

              json.must do
                json.array! ['fuck'] do
                  json.script_score do
                    json.query do
                      json.match_all({})
                    end
                    json.script do
                      json.source "sigmoid(params['_source']['entities'].size(), 2, 2)"
                    end
                  end
                end

                json.array! ['fuck'] do
                  json.nested do
                    json.path 'entities'
                    # json.inner_hits({})
                    json.query do
                      json.function_score do
                        json.query do
                          json.match_all({})
                        end

                        json.functions do
                          (context.required_entity_ids.to_a + context.optional_entity_ids.to_a).each do |entity_id|
                            json.array! ['fuck'] do
                              json.filter do
                                json.term do
                                  json.set! 'entities.entity_id', entity_id
                                end
                              end

                              # json.random_score({})
                              json.weight 2
                            end
                          end

                          # TODO
                          json.array! ['fuck'] do
                            json.set! 'gauss' do
                              json.set! 'entities.created_at' do
                                # "origin": "2013-09-17",
                                json.scale '30d'
                                json.offset '0d'
                                json.decay 0.85
                              end
                            end
                          end
                        end

                        # json.max_boost(80)
                        # json.score_mode('sum')
                        # json.boost_mode('sum')
                        # json.min_score(0)
                      end
                    end
                  end
                end
              end
            end
          end
        end

        if context.required_entity_ids.blank? && context.optional_entity_ids.blank?
          json.set! 'sort' do
            json.array! ['fuck'] do
              json.set! 'entities.mention_date' do
                json.nested do
                  json.path 'entities'
                end
                json.order 'desc'
              end
            end

            json.array! ['fuck'] do
              json.set! 'created_at' do
                json.order 'desc'
              end
            end
          end
        end
      end

      context.object = {}.tap do |h|
        h[:body] = body.attributes!.deep_symbolize_keys
        h[:index] = Elastic::IndexName.pick('mentions').scoped
        h[:size] = context.size
        h[:from] = context.from
        h[:_source] = context._source
      end
    end
  end
end
