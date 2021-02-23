# frozen_string_literal: true

module Feeds
  class Offers
    include ApplicationInteractor

    SELF_NAME_KEY = '*'
    HASH_BANG_KEY = '#'
    CATEGORY_ID_KEY = :feed_category_id
    CATEGORY_IDS_KEY = :feed_category_ids
    ATTEMPT_UUID_KEY = :attempt_uuid
    FAVORITE_IDS_KEY = :favorite_ids
    WRONG_CATEGORY_ERROR = -1
    MULTIPLE_CATEGORY_ERROR = -2
    UNEXPECTED_ATTRIBUTES_KEY = :unexpected_attributes
    UNEXPECTED_ATTRIBUTES_ERROR = -1
    SKIPPED_TAGS = ['delivery-options'].freeze

    INDEXED_AT = :indexed_at

    def initialize(context)
      @offers = []
      super
    end

    def append(doc)
      @current = Hash.new { |hash, key| hash[key] = [] }
      @current[SELF_NAME_KEY] = doc.to_h

      # append attributes if any
      doc.elements.each do |child|
        next if child.name.in?(SKIPPED_TAGS)

        @current[child.name] << hashify(child)
      end

      # patch aliexpress
      if [74, 82, 83, 60, 68, 70, 84, 64, 69, 76, 80, 78, 90, 67, 63, 59, 66,
          62, 61, 65, 72, 77, 75, 71, 73, 87, 85, 88, 81, 79, 89, 86, 58].include?(context.feed.id)
        patch_aliexpress
      end

      # append our category
      enrich_category

      # append attempt_uuid
      enrich_attempt_uuid

      # set language in @current
      Import::Offers::Language.call(@current)

      # enrich indexed_at
      enrich_indexed_at

      # enrich favorite_ids
      enrich_favorite_ids

      @offers << @current
    end

    def flush
      return if @offers.empty?

      client = Elasticsearch::Client.new Rails.application.config.elastic
      res = client.bulk(
        index: Elastic::IndexName.offers,
        routing: context.feed.id,
        body: @offers.map do |offer|
          {
            index: {
              _id: "#{offer[SELF_NAME_KEY]['id']}-#{context.feed.id}",
              data: offer.merge(feed_id: context.feed.id, advertiser_id: context.feed.advertiser.id)
            }
          }
        end
      )
      raise Feeds::Process::ElasticResponseError, res['errors'] if res['errors']

      @offers = []
    end

    def size
      @offers.size
    end

    private

    def hashify(child)
      hsh = GlobalHelper.hashify(child)

      if child.attributes.size > 2
        Rails.logger.warn("Offer child tag '#{child.inspect}' has more than 2 attributes")
        hsh[UNEXPECTED_ATTRIBUTES_KEY] = UNEXPECTED_ATTRIBUTES_ERROR
      end

      raise Feeds::Process::ElasticUnexpectedNestingError, child.to_s unless child.elements.empty?

      # TODO: is it safe to use CDATA? What about XSS?
      raise Feeds::Process::ElasticUnexpectedNestingError, child.to_s if child.children.reject(&:text?).size > 1

      hsh
    end

    def patch_aliexpress
      @current['name'] = @current.delete('title') if @current.key?('title')
      @current['picture'] = @current.delete('image') if @current.key?('image')
    end

    def enrich_attempt_uuid
      @current[ATTEMPT_UUID_KEY] = context.feed.attempt_uuid
    end

    def enrich_category
      return unless @current.key?('categoryId')

      category_value = @current['categoryId']

      if category_value.size > 1
        Rails.logger.warn('Offer has multiple categoryId')
        @current[CATEGORY_ID_KEY] = MULTIPLE_CATEGORY_ERROR
        @current[CATEGORY_IDS_KEY] = MULTIPLE_CATEGORY_ERROR
      end

      ext_category_id = category_value.first[HASH_BANG_KEY]
      feed_category = FeedCategory.find_by(feed_id: context.feed.id, ext_id: ext_category_id)
      if feed_category
        if feed_category.children?
          feed_category = feed_category
                          .children
                          .find_or_create_by!(feed_id: context.feed.id, ext_id: "#{ext_category_id}!") do |fc|
            fc.attempt_uuid = context.feed.attempt_uuid
          end
        end
        @current[CATEGORY_ID_KEY] = feed_category.id
        @current[CATEGORY_IDS_KEY] = feed_category.path_ids
        feed_category.path_ids.each_with_index.map do |id, idx|
          @current["#{CATEGORY_ID_KEY}_#{idx}"] = id
        end
      else
        Rails.logger.warn("Offer categoryId is '#{ext_category_id}' but it was not found in <categories>")
        @current[CATEGORY_ID_KEY] = WRONG_CATEGORY_ERROR
        @current[CATEGORY_IDS_KEY] = [WRONG_CATEGORY_ERROR]
        @current["#{CATEGORY_ID_KEY}_0"] = WRONG_CATEGORY_ERROR
      end
      # @current[:feed_category_id] = @categories_cache.find_by_ext_id(@current['categoryId'].first[HASH_BABG])
      # @current[:feed_category_path] = @categories.tree(@current[:feed_category_id])
    end

    def enrich_indexed_at
      @current[INDEXED_AT] = Time.current
    end

    def enrich_favorite_ids
      @current[FAVORITE_IDS_KEY] = [
        "advertiser_id:#{context.feed.advertiser.id}",
        "feed_id:#{context.feed.id}",
        *@current[CATEGORY_IDS_KEY].map { |feed_category_id| "feed_category_id:#{feed_category_id}" }
      ]
    end

    # .reject { |el| el.blank? }
    # .map { |arr| arr.map { |b| b[HASH_BANG_KEY] }}.join(' - ')

    # class CategoriesCache
    #   def initialize(feed_id)
    #     @serialized_tree = FeedCategory.where(feed_id: feed_id)
    #                            .select('id, ext_id, ancestry_depth as level, ancestry').arrange_serializable
    #   end
    #
    #   def find_by_ext_id(ext_id)
    #     @serialized_tree.each do |category|
    #       res = traverse(ext_id, category)
    #       return res if res
    #     end
    #   end
    #
    #   def tree
    #     debugger
    #     p 1
    #   end
    #
    #   def traverse(ext_id, category)
    #     if category['ext_id'] == ext_id
    #       return category['id']
    #     elsif category['children']
    #       category['children'].each do |child|
    #         res = inner_traverse(ext_id, category['children'])
    #         break res if res
    #       end
    #     end
    #     children.each do |child|
    #       if category['ext_id'] == ext_id
    #         break category['id']
    #       elsif
    #
    #       end
    #     end
    #
    #
    #   end
    # end
  end
end
