# frozen_string_literal: true

module API
  class Mentions < ::Grape::API
    prefix :api

    resource :mentions do
      params do
        optional :q, type: String, desc: 'Search string', documentation: { param_type: 'body' }
        optional :entity_ids, type: Array[Integer]
        optional :per
        optional :page
        optional :sort
      end

      post do
        ::Mentions::IndexInteractor.call(
          params: params,
          current_user: current_user,
          request: request,
          entity_ids: params[:entity_ids]
        ).object
      end

      # get :entities do
      #   object = Mentions::EntitiesInteractor.call(q: params[:q]).object
      #   object = Decorators::Mentions::Entities.call(object: object).object
      #   object
      # end
      #
      # get :urls do
      #   object = Mentions::UrlsInteractor.call(q: params[:q]).object
      #   object = Decorators::Mentions::Urls.call(object: object).object
      #   object
      # end
    end
  end
end
