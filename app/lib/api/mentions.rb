# frozen_string_literal: true

module API
  class Mentions < ::Grape::API
    prefix :api
    auth :api_key

    resource :mentions do
      # desc 'Autocomplete entities' do
      #   security [{ api_key: [] }]
      # end
      #
      # params do
      #   requires :q, type: String, desc: 'Search string'
      # end
      #
      # get :entities do
      #   object = Interactors::Mentions::Entities.call(q: params[:q]).object
      #   object = Decorators::Mentions::Entities.call(object: object).object
      #   object
      # end
      #
      # desc 'Autocomplete urls' do
      #   security [{ api_key: [] }]
      # end
      #
      # params do
      #   requires :q, type: String, desc: 'Search string'
      # end
      #
      # get :urls do
      #   object = Interactors::Mentions::Urls.call(q: params[:q]).object
      #   object = Decorators::Mentions::Urls.call(object: object).object
      #   object
      # end
    end
  end
end
