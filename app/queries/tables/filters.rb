# frozen_string_literal: true

# TODO: to test isolated for json query

module Tables
  class Filters
    include ApplicationInteractor
    delegate :json, to: :context

    contract do
      params do
        # TODO: make it better?
        # config.validate_keys = true
        required(:json)
        required(:filters)
        required(:model)
      end
    end

    def call
      context.object = _filter
    end

    private

    def _filter
      if context.filters.present?
        json.array! ['fuck!'] do
          json.bool do
            json.filter do
              settings = GlobalHelper.class_configurator(context.model)

              context.filters.each do |column, rules|
                elastic_column = settings[:form_class].elastic_column(column)
                case elastic_column[:type]
                when :date
                  json.array! ['fuck'] do
                    json.range do
                      json.set!(column) do
                        json.gte Time.zone.parse(context.filters[column]['min']).iso8601
                        json.lte Time.zone.parse(context.filters[column]['max']).iso8601
                      end
                    end
                  end
                when :long, :double
                  json.array! ['fuck'] do
                    json.range do
                      json.set!(column) do
                        json.gte context.filters[column]['min']
                        json.lte context.filters[column]['max']
                      end
                    end
                  end
                when :text
                  json.array! ['fuck'] do
                    # json.match do
                    #   json.set!(column, context.filters[column]['value'])
                    # end
                    json.multi_match do
                      json.query context.filters[column]['value']
                      json.type 'bool_prefix'
                      json.fields %W[
                        #{column}.autocomplete
                        #{column}.autocomplete._2gram
                        #{column}.autocomplete._3gram
                      ]
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
