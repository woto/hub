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

    def currencies_table
      Money::Currency.table.map { |key, value| { key => value[:iso_numeric].to_i } }
                     .reduce(&:merge)
                     .reject { |k, _| k.in?(%i[all try]) }
                     .reject { |_, v| v.zero? }
    end

    def create_index(client, model)
      elastic_client.indices.create(
        index: model.index_name,
        body: {
          settings: model.settings.to_hash,
          mappings: model.mappings.to_hash
        }
      )
    end

    def elastic_client
      Elasticsearch::Client.new(Rails.application.config.elastic)
    end

    def create_elastic_indexes
      elastic_client

      Elastic::CreateOffersIndex.call
      Elastic::CreateTokenizerIndex.call

      User.setup_index(Columns::UserForm)
      create_index(elastic_client, User)

      Feed.setup_index(Columns::FeedForm)
      create_index(elastic_client, Feed)

      Post.setup_index(Columns::PostForm)
      create_index(elastic_client, Post)

      Favorite.setup_index(Columns::FavoriteForm)
      create_index(elastic_client, Favorite)

      Account.setup_index(Columns::AccountForm)
      create_index(elastic_client, Account)

      Transaction.setup_index(Columns::TransactionForm)
      create_index(elastic_client, Transaction)

      Check.setup_index(Columns::CheckForm)
      create_index(elastic_client, Check)

      PostCategory.setup_index(Columns::PostCategoryForm)
      create_index(elastic_client, PostCategory)

      PostCategory.setup_index(Columns::ExchangeRateForm)
      create_index(elastic_client, ExchangeRate)

      PostCategory.setup_index(Columns::RealmForm)
      create_index(elastic_client, Realm)

      elastic_client.indices.refresh
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
      child.to_h.transform_keys { |k| "@#{k}" }.merge('#' => child.text)
    end
  end
end
