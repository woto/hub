# frozen_string_literal: true

module API
  class Posts < ::Grape::API
    prefix :api

    resource :posts do
      desc 'Autocompletes tags'

      params do
        requires :q, type: String, desc: 'Search string'
        requires :realm_id, type: Integer, desc: 'Realm id', allow_blank: false
      end

      get :tags do
        Interactors::Posts::Tags.call(q: params[:q], realm_id: params[:realm_id]).object
      end
    end
  end
end
