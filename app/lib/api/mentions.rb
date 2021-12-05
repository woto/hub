# frozen_string_literal: true

module API
  class Mentions < ::Grape::API
    prefix :api

    resource :mentions do
      desc 'Autocomplete entities'

      params do
        requires :q, type: String, desc: 'Search string'
      end

      get :entities do
        object = Interactors::Mentions::Entities.call(q: params[:q]).object
        object = Decorators::Mentions::Entities.call(object: object).object
        object
      end

      desc 'Autocomplete urls'

      params do
        requires :q, type: String, desc: 'Search string'
      end

      get :urls do
        Interactors::Mentions::Urls.call(q: params[:q]).object
      end

      desc 'Autocomplete tags'

      params do
        requires :q, type: String, desc: 'Search string'
      end

      get :tags do
        Interactors::Mentions::Tags.call(q: params[:q], sort: 'mentions_count', order: 'desc', limit: 10).object
      end

    end
  end
end
