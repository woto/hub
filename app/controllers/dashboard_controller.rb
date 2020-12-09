# frozen_string_literal: true

class DashboardController < ApplicationController
  # skip_after_action :verify_policy_scoped
  layout 'backoffice'
  skip_before_action :authenticate_user!

  def index
    if current_user
      account_ids = current_user.accounts.pluck("id")
      client = Elasticsearch::Client.new Rails.application.config.elastic
      @test = client.search(
        index: ::Elastic::IndexName.transactions,
        body: {
          "size": 0,
          "aggs": {
            "by_debit_id": {
              "filter": {
                "terms": {
                  "debit_id": account_ids
                }
              },
              "aggs": {
                "by_debit_code": {
                  "terms": {
                    "field": 'debit_code.keyword'
                  },
                  "aggs": {
                    "by_created_at": {
                      "date_histogram": {
                        "field": 'created_at',
                        "calendar_interval": 'day'
                      },
                      "aggs": {
                        "by_debit_amount": {
                          "top_metrics": {
                            "metrics": { "field": 'debit_amount' },
                            "sort": { "created_at": 'desc' }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      )
      p 1
    end
  end
end
