# frozen_string_literal: true

class OffersSearchQuery
  include ApplicationInteractor

  # TODO: refactor with elasticsearch-dsl or jbuilder (as described in examples)
  # Code fully covered by tests in spec/lib/queries/offers_search_query_spec.rb
  def call
    mash = Hashie::Mash.new
    mash.index = ::Elastic::IndexName.offers(context.feed_id || '*')

    if context.q.present?
      mash.body = Hashie::Mash.new unless mash.body?
      mash.body.query = Hashie::Mash.new unless mash.body.query?
      mash.body.query.bool = Hashie::Mash.new unless mash.body.query.bool?
      mash.body.query.bool.must = [] if mash.body.query.bool.filter.blank?
      mash.body.query.bool.must <<
        {
          query_string: {
            query: context.q

          }
        }

      mash.body.highlight = Hashie::Mash.new unless mash.body.highlight?
      mash.body.highlight = { tags_schema: :styled, fields: [{ 'description.#' => {}}, {'name.#' => {}}] }

      # mash.body.query.bool = Hashie::Mash.new unless mash.body.query.bool?
      # mash.body.query.bool.must = [] if mash.body.query.bool.filter.blank?
      # mash.body.query.bool.must <<
      #     { multi_match: { "fields": ['name.#^2', 'description.#'], 'query': context.q  } }

      # mash.body.query.bool = Hashie::Mash.new unless mash.body.query.bool?
      # mash.body.query.bool.must = [] if mash.body.query.bool.filter.blank?
      # mash.body.query.bool.must <<
      #     {
      #         "simple_query_string": {
      #             "fields": [
      #                 'name.#.keyword^2',
      #                 'name.#'
      #             ],
      #             "query": context.q,
      #             "default_operator": 'or',
      #             "analyze_wildcard": true,
      #             "minimum_should_match": '-85%'
      #         }
      #     }
    else
      mash.body = Hashie::Mash.new unless mash.body?
      mash.body.query = Hashie::Mash.new unless mash.body.query?
      mash.body.query.bool = Hashie::Mash.new unless mash.body.query.bool?
      mash.body.query.bool.filter = [] if mash.body.query.bool.filter.blank?
      mash.body.query.bool.filter << { "match_all": {} }
    end

    if context.profile.present?
      mash.body = Hashie::Mash.new unless mash.body?
      mash.body.query = Hashie::Mash.new unless mash.body.query?
      mash.body.profile = true
    end

    if context.explain.present?
      mash.body = Hashie::Mash.new unless mash.body?
      mash.body.query = Hashie::Mash.new unless mash.body.query?
      mash.body.explain = true
    end

    if context.category_id.present?
      mash.body = Hashie::Mash.new unless mash.body?
      mash.body.query = Hashie::Mash.new unless mash.body.query?
      mash.body.query.bool = Hashie::Mash.new unless mash.body.query.bool?
      mash.body.query.bool.filter = [] if mash.body.query.bool.filter.blank?
      if context.only
        mash.body.query.bool.filter << { term: { 'feed_category_id' => context.category_id } }
      else
        mash.body.query.bool.filter << { term: { "category_level_#{context.level}" => context.category_id } }
      end
    end

    mash.body = Hashie::Mash.new unless mash.body?
    mash.body.aggs = Hashie::Mash.new unless mash.body.aggs?
    unless mash.body.aggs.categories?
      mash.body.aggs.categories = Hashie::Mash.new
    end
    unless mash.body.aggs.categories.terms?
      mash.body.aggs.categories.terms = Hashie::Mash.new
    end
    mash.body.aggs.categories.terms.field = if context.category_id
                                              "category_level_#{context.level + 1}"
                                            else
                                              "category_level_#{context.level}"
                                            end
    mash.body.aggs.categories.terms.size = 20

    if context.category_id.present?
      # Only this category without children
      mash.body = Hashie::Mash.new unless mash.body?
      mash.body.aggs = Hashie::Mash.new unless mash.body.aggs?
      mash.body.aggs.category = Hashie::Mash.new unless mash.body.aggs.category
      unless mash.body.aggs.category.filter?
        mash.body.aggs.category.filter = Hashie::Mash.new
      end
      unless mash.body.aggs.category.filter.term?
        mash.body.aggs.category.filter.term = Hashie::Mash.new
      end
      mash.body.aggs.category.filter.term.feed_category_id = context.category_id
      # mash.body.aggs.category.aggs = Hashie::Mash.new unless mash.body.aggs.category.aggs?
      # mash.body.aggs.category.aggs.category = Hashie::Mash.new unless mash.body.aggs.category.aggs.category?
      # mash.body.aggs.category.aggs.category.terms = Hashie::Mash.new unless mash.body.aggs.category.aggs.category.terms?
      # mash.body.aggs.category.aggs.category.terms.field = 'feed_category_id'
    end

    if context.feed_id.blank?
      mash.body = Hashie::Mash.new unless mash.body?
      mash.body.aggs = Hashie::Mash.new unless mash.body.aggs?
      mash.body.aggs.feeds = Hashie::Mash.new unless mash.body.aggs.feeds?
      unless mash.body.aggs.feeds.terms?
        mash.body.aggs.feeds.terms = Hashie::Mash.new
      end
      mash.body.aggs.feeds.terms.field = '_index'
      mash.body.aggs.feeds.terms.size = 20
    end

    if context.feed_id.blank? && context.category_id.blank? && context.q.blank?
      mash.body = Hashie::Mash.new unless mash.body?
      mash.body.sort = { Feeds::Offers::INDEXED_AT => { order: :desc } }
    end

    context.object = JSON.parse(mash.to_json).deep_symbolize_keys
  end
end
