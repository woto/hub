class Mixes::Search1Controller < ApplicationController
  def index

    client = Elasticsearch::Client.new Rails.application.config.elastic

    tokens = Elastic::Tokenize.call(q: params[:q]).object

    # GET development.offers/_search
    body = {
      "size": 0,
      "query": {
        "bool": {
          "should": [
            {
              "multi_match": {
                "query": params[:q],
                "fields": [
                  "name.#^3",
                  "feed_category_names",
                  "description.#"
                ]
              }
            }
          ],
          "must": [
            {
              "multi_match": {
                "query": params[:q],
                "fields": [
                  "name.#^3",
                  "feed_category_name",
                  "description.#"
                ],
                "type": "most_fields",
                "fuzziness": "AUTO",
                "minimum_should_match": tokens.count
              }
            }
          ]
        }
      },
      "aggs": {
        "advertisers": {
          "terms": {
            "field": "advertiser_name.keyword",
            "order": {
              "top_hit": "desc"
            },
            "size": 500
          },
          "aggs": {
            "top_offers": {
              "top_hits": {
                "size": 10
              }
            },
            "top_hit": {
              "max": {
                "script": {
                  "source": "_score"
                }
              },
            }
          }
        }
      }
    }

    req = {
      index: ::Elastic::IndexName.offers,
      body: body
    }

    @results = client.search(req)
  end
end
