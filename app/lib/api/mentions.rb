# frozen_string_literal: true

module API
  class Mentions < ::Grape::API
    prefix :api

    resource :mentions do
      desc 'List mentions'

      params do
        optional :entity_ids, type: Array[Integer], documentation: { param_type: 'body' }
        optional :listing_id, type: Integer
        optional :mention_id, type: Integer
        optional :mentions_search_string, type: String, desc: 'Search string'
        optional :sort, type: String
        optional :page, type: Integer
        optional :per, type: Integer
        optional :page, type: Integer
      end

      post 'list' do
        ::Mentions::IndexInteractor.call(
          current_user:,
          params:
        ).object
      end

      # get :urls do
      #   object = Mentions::UrlsInteractor.call(q: params[:q]).object
      #   object = Decorators::Mentions::Urls.call(object: object).object
      #   object
      # end
    end
  end
end
