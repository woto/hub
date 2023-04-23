# frozen_string_literal: true

module API
  class Cites < ::Grape::API
    prefix :api

    resource :cites do

      desc 'Index Cites' do
        # security [{ api_key: [] }]
      end

      params do
        requires :entity_id, type: String
      end

      get do
        ::Entities::TimelineInteractor.call(entity_id: params[:entity_id], count: 5).object
      end

      auth :api_key

      desc 'Creates new Cite' do
        security [{ api_key: [] }]
      end

      params do
        optional :entity_id, type: Integer, documentation: { param_type: 'body' }
        requires :title, type: String
        requires :intro, type: String
        optional :mention_date, type: Date
        requires :fragment_url, type: String
        requires :link_url, type: String
        optional :relevance, type: Integer
        optional :sentiment, type: Integer
        optional :topics, type: Array do
          requires :id, type: Integer
          requires :destroy, type: Boolean
          requires :title, type: String
        end
        optional :images, type: Array do
          requires :id, type: Integer
          requires :destroy, type: Boolean
          optional :json, type: JSON, allow_blank: true
          requires :dark, type: Boolean
        end
        optional :lookups, type: Array do
          requires :id, type: Integer
          requires :destroy, type: Boolean
          requires :title, type: String
        end
      end

      post do
        Cites::CreateInteractor.call(params: params, current_user: current_user).object
      end
    end
  end
end
