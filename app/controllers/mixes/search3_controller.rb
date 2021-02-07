class Mixes::Search3Controller < ApplicationController
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
              "span_near": {
                "clauses":
                  tokens.map do |token|
                    {
                      "span_multi": {
                        "match": {
                          "fuzzy": {
                            "name.#": {
                              "fuzziness": 'auto',
                              "value": token
                            }
                          }
                        }
                      }
                    }
                  end,
                "slop": 10,
                "in_order": 'false'
              }
            },
            {
              "span_near": {
                "clauses":
                  tokens.map do |token|
                    {
                      "span_multi": {
                        "match": {
                          "fuzzy": {
                            "description.#": {
                              "fuzziness": 'auto',
                              "value": token
                            }
                          }
                        }
                      }
                    }
                  end,
                "slop": 10,
                "in_order": 'false'
              }
            },
          # {
          #   "multi_match": {
          #     "query": params[:q],
          #     "fields": [
          #       "name.#^3",
          #       "feed_category_names",
          #       "description.#"
          #     ]
          #   }
          # }
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
              "top_hit[99.0]": "desc"
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
              "percentiles": {
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
