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
        # security [{ api_key: [] }]
      end

      params do
        optional :mentions_search_string, type: String, desc: 'Mentions search string', documentation: { param_type: 'body' }
        optional :entities_search_string, type: String, desc: 'Entities search string'
        optional :entity_ids, type: Array[Integer], desc: 'related entities ids'
      end

      post 'related' do
        ::Entities::RelatedInteractor.call(
          mentions_search_string: params[:mentions_search_string],
          entities_search_string: params[:entities_search_string],
          entity_ids: params[:entity_ids]
        ).object
      end

      desc 'Search entities' do
        # security [{ api_key: [] }]
      end

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

      desc 'List entities'

      params do
        optional :entity_ids, type: Array[Integer], documentation: { param_type: 'body' }
        optional :listing_id, type: Integer
        optional :mention_id, type: Integer
      end

      post 'list' do
        ::Entities::IndexInteractor.call(
          mention_id: params[:mention_id]&.to_i,
          listing_id: params[:listing_id]&.to_i,
          entity_ids: params[:entity_ids]&.map(&:to_i),
          current_user:,
          request:
        ).object
      end

      auth :api_key
    end
  end
end
