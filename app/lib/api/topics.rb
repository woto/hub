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
          ::Topics::ElasticsearchInteractor.call(q: params[:q]).object
        else
          # TODO: check this. Seems not used anymore.
          # I simple have to figure out how to send request to Elastic with empty :q
          ::Topics::PostgresqlInteractor.call(q: params[:q]).object
        end
      end
    end
  end
end
