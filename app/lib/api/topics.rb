# frozen_string_literal: true

module API
  class Topics < ::Grape::API
    prefix :api

    resource :topics do
      desc 'List topics' do
        security [{ api_key: [] }]
      end

      params do
        optional :q, type: String, desc: 'Search string'
      end

      get do
        if params[:q].present?
          Interactors::Topics::Elasticsearch.call(q: params[:q]).object
        else
          Interactors::Topics::Postgresql.call(q: params[:q]).object
        end
      end
    end
  end
end
