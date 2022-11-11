# frozen_string_literal: true

module API
  class Entities < ::Grape::API
    prefix :api

    resource :entities do
      desc 'Show random entity' do
        # security [{ api_key: [] }]
      end

      get 'random' do
        ::Entities::GetInteractor.call.object
      end

      desc 'Show requested entity' do
        # security [{ api_key: [] }]
      end

      get ':id' do
        ::Entities::GetInteractor.call(id: params[:id]).object
      end

      desc 'related entities' do
        security [{ api_key: [] }]
      end

      params do
        optional :q, type: String, desc: 'query string', documentation: { param_type: 'body' }
        optional :entity_ids, type: Array[Integer], desc: 'related entities ids'
        optional :entity_title, type: String, desc: 'title of searched entity'
      end

      post 'related' do
        ::Entities::RelatedInteractor.call(
          q: params[:q],
          entity_ids: params[:entity_ids],
          entity_title: params[:entity_title]
        ).object
      end

      desc 'Search entities' do
        # security [{ api_key: [] }]
      end

      # desc 'Search mentions' do
      #   security [{ api_key: [] }]
      # end

      params do
        requires :fragment_url, type: String, documentation: { param_type: 'body' }, desc: 'Highlighted fragment url'
        optional :search_string, type: String, desc: 'Manually crafted search string'
      end

      post :seek do
        ::Entities::SeekInteractor.call(
          fragment_url: params[:fragment_url],
          search_string: params[:search_string],
          link_url: params[:link_url],
          pagination_rule: PaginationRules.new(request)
        ).object
      end

      auth :api_key
    end
  end
end
