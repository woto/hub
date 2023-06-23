# frozen_string_literal: true

class ThingsSearchQuery
  include ApplicationInteractor

  contract do
    params do
      required(:fragment).value(type?: Fragment::Struct)
      required(:search_string).maybe(:str?)
      required(:link_url).maybe(:str?)
      required(:from).filled(:integer)
      required(:size).filled(:integer)
    end
  end

  def call
    # debugger
    first_text = context.fragment.texts.first

    body = Jbuilder.new do |json|
      json.query do
        json.bool do

          if context[:search_string]
            json.set! :should do
              json.array! ['fuck'] do
                json.multi_match do
                  json.query context[:search_string]
                  json.type 'bool_prefix'
                  json.fields do
                    json.array! %w[
                      title.autocomplete^2
                      title.autocomplete._2gram^2
                      title.autocomplete._3gram^2
                    ]
                  end
                end
              end
            end
          end

          if context[:search_string].present?
            json.set! :should do
              json.array! ['fuck'] do
                json.multi_match do
                  json.query context.search_string
                  json.fields %w[title lookups.title text_start]
                  json.boost 2
                end
              end
            end
          end

          if context[:search_string].present?
            json.set! :should do
              json.array! ['fuck'] do
                json.multi_match do
                  json.query context[:search_string]
                  json.fields %w[title intro lookups.title text_start text_end prefix suffix link_url]
                  json.boost 0.2
                end
              end
            end
          end

          if context[:search_string].present?
            json.set! :should do
              json.array! ['fuck'] do
                json.multi_match do
                  json.query context[:search_string]
                    .split(/\W/)
                    .flatten
                    .select { |chunk| chunk.size > 3 }
                    .compact_blank.join(' ')
                  json.fields %w[title intro lookups.title text_start text_end prefix suffix link_url]
                  json.boost 2.5
                end
              end
            end
          end

          if context[:fragment]
            set = [[:prefix, 0.2], [:text_start, 0.2], [:text_end, 0.2], [:suffix, 0.2]]
            set.each do |field, boost|
              next if !first_text || first_text[field].blank?

              json.set! :should do
                json.array! ['fuck'] do
                  json.multi_match do
                    json.query first_text[field]
                    json.fields %w[title intro lookups.title text_start text_end prefix suffix link_url]
                    json.boost boost
                    json.fuzziness 'AUTO'
                  end
                end
              end
            end
          end

          if context[:link_url].present?
            uri = URI.parse(context[:link_url])

            json.set! :should do
              json.array! ['fuck'] do

                json.multi_match do
                  json.query [
                    uri.host.split(/\W/),
                    uri.path.split(/\W/),
                    uri.query.to_s.split(/\W/)]
                    .flatten
                    .select { |chunk| chunk.size > 3 }
                    .compact_blank.join(' ')
                  json.fields %w[title lookups.title text_start]
                  json.boost 3
                  json.fuzziness 'AUTO'
                end
              end
            end
          end

          if context[:link_url].present?
            json.set! :should do
              json.array! ['fuck'] do
                json.term do
                  json.set! "link_url.keyword" do
                    json.value context[:link_url]&.chomp('/')
                    json.boost Rails.application.config.global[:perfect_match_score_boost]
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
      h[:index] = Elastic::IndexName.pick('entities').scoped
      h[:size] = context.size
      h[:from] = context.from
      # h[:_source] = context._source
    end
  end
end
