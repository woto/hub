# TODO: remove
class Mixes::Search1Controller < ApplicationController
  def index

    client = Elasticsearch::Client.new Rails.application.config.elastic

    tokens = Elastic::Tokenize.call(q: params[:q]).object
    search_string = tokens.join(' ')

    # GET development.offers/_search
    body = {
      "size": 0,
      "query": {
        "bool": {
          "should": [
            {
              "multi_match": {
                "query": search_string,
                "fields": [
                  "name.#^3",
                  "description.#"
                ]
              }
            }
          ],
          "filter": [
            {
              "multi_match": {
                "query": search_string,
                "fields": [
                  "name.#^3",
                  "description.#"
                ],
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
              "top_hit.sum_of_squares": "desc"
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
              "extended_stats": {
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
