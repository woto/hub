# frozen_string_literal: true

class GlobalHelper
  FAVORITE_COLUMN = 'favorite'
  MULTIPLICATOR = 6
  GROUP_NAME = :group
  GROUP_LIMIT = 1000

  class << self
    def class_configurator(model)
      { singular: model.to_s.singularize.to_sym,
        plural: model.to_s.pluralize.to_sym,
        model_class: model.to_s.singularize.camelize.safe_constantize,
        form_class: "Columns::#{model.to_s.singularize.camelize}Form".constantize,
        query_class: "#{model.to_s.pluralize.camelize}SearchQuery".constantize,
        decorator_class: "#{model.to_s.singularize.camelize}Decorator".constantize,
        favorites_kind: model.to_s.pluralize.to_sym,
        favorites_items_kind: model.to_s.pluralize.to_sym }
    end

    def tid_helper(identity, tid)
      "#{identity}:#{tid}"
    end

    def currencies_table
      Money::Currency.table.map { |key, value| { key => value[:iso_numeric].to_i } }
                     .reduce(&:merge)
                     .reject { |k, _| k.in?(%i[all try]) }
                     .reject { |_, v| v.zero? }
    end

    def elastic_client
      Elasticsearch::Client.new(Rails.application.config.elastic)
    end

    def create_elastic_indexes
      elastic_client

      Elastic::CreateOffersIndex.call
      Elastic::CreateTokenizerIndex.call

      Elastic::CreateIndex.call(index_name: 'user')
      Elastic::CreateIndex.call(index_name: 'feed')
      Elastic::CreateIndex.call(index_name: 'post')
      Elastic::CreateIndex.call(index_name: 'favorite')
      Elastic::CreateIndex.call(index_name: 'account')
      Elastic::CreateIndex.call(index_name: 'transaction')
      Elastic::CreateIndex.call(index_name: 'check')
      Elastic::CreateIndex.call(index_name: 'post_category')
      Elastic::CreateIndex.call(index_name: 'exchange_rate')
      Elastic::CreateIndex.call(index_name: 'realm')
      Elastic::CreateIndex.call(index_name: 'mention')
      Elastic::CreateIndex.call(index_name: 'entity')

      elastic_client.indices.refresh index: Elastic::IndexName.wildcard
    end

    def decorate_datetime(datetime)
      return ActionController::Base.helpers.tag.span('&nbsp;'.html_safe) if datetime.blank?

      datetime = Time.zone.parse(datetime) if datetime.is_a?(String)

      ActionController::Base.helpers.tag.span(
        datetime.iso8601,
        style: 'cursor: pointer',
        "data-controller": 'timeago',
        'data-timeago-source-time-value': datetime.iso8601,
        "data-action": 'click->timeago#toggleSourceTime'
      )
    end

    def decorate_text(text)
      ActionController::Base.helpers.link_to(
        I18n.t('view'),
        '#',
        'data-controller': 'modal-static-opener',
        'data-action': 'modal-static-opener#open',
        'data-modal-static-opener-text-value': text
      )
    end

    def decorate_money(amount, currency)
      c = Money::Currency.new(currency)
      ActionController::Base.helpers.number_to_currency(amount,
                                                        unit: c.symbol,
                                                        separator: c.decimal_mark,
                                                        delimiter: c.thousands_separator,
                                                        locale: :en)
    end

    def retryable
      attempt = 0
      begin
        attempt += 1
        ActiveRecord::Base.transaction(isolation: :serializable) do
          result = yield
          result
        end
      rescue ActiveRecord::SerializationFailure => e
        Rails.logger.warn(e)
        retry if attempt != 5
        raise
      end
    end

    def hashify(child)
      child.to_h.transform_keys { |k| "@#{k}" }.merge('#' => sanitize(child.text))
    end

    def sanitize(text)
      Loofah.fragment(text).to_text(encode_special_chars: false).strip
    end
  end
end
