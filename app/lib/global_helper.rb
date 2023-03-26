# frozen_string_literal: true

class GlobalHelper
  FAVORITE_COLUMN = 'favorite'
  MULTIPLICATOR = 6
  GROUP_NAME = :group
  GROUP_LIMIT = 1000

  class << self
    def host
      "#{ENV.fetch('PUBLIC_SCHEMA')}://#{ENV.fetch('PUBLIC_DOMAIN')}:#{ENV.fetch('PUBLIC_PORT')}"
    end

    def image_hash(images_relations, resolutions)
      images_relations.map do |images_relation|
        # debugger if object.class != Image
        # images_relation = object.images_relations#.where(relation_type: 'Entity')

        # empty_image = {
        #   '50' => ApplicationController.helpers.asset_pack_path('media/images/icon-404-50.png'),
        #   '100' => ApplicationController.helpers.asset_pack_path('media/images/icon-404-100.png'),
        #   '200' => ApplicationController.helpers.asset_pack_path('media/images/icon-404-200.png'),
        #   '300' => ApplicationController.helpers.asset_pack_path('media/images/icon-404-300.png'),
        #   '500' => ApplicationController.helpers.asset_pack_path('media/images/icon-404-500.png'),
        #   '1000' => ApplicationController.helpers.asset_pack_path('media/images/icon-404-1000.png')
        # }

        {
          'id' => images_relation.image.id,
          'original' => images_relation.image ? images_relation.image.image_url : nil,
          'images' =>
            resolutions.map do |resolution|
              [
                resolution.to_s,
                if images_relation.image
                  images_relation.image.image.derivation_url(:image, resolution.to_i, resolution.to_i)
                end
              ]
            end.to_h,
          'videos' =>
            resolutions.map do |resolution|
              [
                resolution.to_s,
                if images_relation.image
                  images_relation.image.image.derivation_url(:video, resolution.to_i, resolution.to_i)
                end
              ]
            end.to_h,
          'width' => images_relation.image ? images_relation.image.image.metadata['width'] : nil,
          'height' => images_relation.image ? images_relation.image.image.metadata['height'] : nil,
          'mime_type' => images_relation.image.image.mime_type,
          'dark' => images_relation.dark
        }
      end
    end

    def class_configurator(model)
      form_class = case model
                   when 'mention', 'entity'
                     nil
                   else
                     "Columns::#{model.to_s.pluralize.camelize}Mapping".constantize
                   end

      { singular: model.to_s.singularize.to_sym,
        plural: model.to_s.pluralize.to_sym,
        model_class: model.to_s.singularize.camelize.safe_constantize,
        form_class:,
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

      Elastic::CreateIndex.call(index: Elastic::IndexName.pick('users'))
      Elastic::CreateIndex.call(index: Elastic::IndexName.pick('feeds'))
      Elastic::CreateIndex.call(index: Elastic::IndexName.pick('posts'))
      Elastic::CreateIndex.call(index: Elastic::IndexName.pick('favorites'))
      Elastic::CreateIndex.call(index: Elastic::IndexName.pick('accounts'))
      Elastic::CreateIndex.call(index: Elastic::IndexName.pick('transactions'))
      Elastic::CreateIndex.call(index: Elastic::IndexName.pick('checks'))
      Elastic::CreateIndex.call(index: Elastic::IndexName.pick('post_categories'))
      Elastic::CreateIndex.call(index: Elastic::IndexName.pick('exchange_rates'))
      Elastic::CreateIndex.call(index: Elastic::IndexName.pick('realms'))
      Elastic::CreateIndex.call(index: Elastic::IndexName.pick('mentions'))
      Elastic::CreateIndex.call(index: Elastic::IndexName.pick('entities'))
      Elastic::CreateIndex.call(index: Elastic::IndexName.pick('topics'))

      elastic_client.indices.refresh index: Elastic::IndexName.pick('*').scoped
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
