# frozen_string_literal: true

module API
  class Posts < ::Grape::API
    prefix :api
    auth :api_key

    resource :posts do
      desc 'Autocomplete tags' do
        security [{ api_key: [] }]
      end

      params do
        requires :q, type: String, desc: 'Search string'
        requires :realm_id, type: Integer, desc: 'Realm id', allow_blank: false
      end

      get :tags do
        Interactors::Posts::Tags.call(q: params[:q], realm_id: params[:realm_id]).object
      end

      desc 'Autocomplete leaf categories' do
        security [{ api_key: [] }]
      end

      params do
        requires :q, type: String, desc: 'Search string'
        requires :realm_id, type: Integer, desc: 'Realm id', allow_blank: false
      end

      get :leaf_categories do
        Interactors::Posts::LeavesCategories.call(q: params[:q], realm_id: params[:realm_id]).object
      end

      desc 'Autocomplete empty categories' do
        security [{ api_key: [] }]
      end

      params do
        requires :q, type: String, desc: 'Search string'
        requires :realm_id, type: Integer, desc: 'Realm id', allow_blank: false
      end

      get :empty_categories do
        Interactors::Posts::EmptyCategories.call(q: params[:q], realm_id: params[:realm_id]).object
      end
    end
  end
end
