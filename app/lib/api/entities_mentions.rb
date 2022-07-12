# frozen_string_literal: true

module API
  class EntitiesMentions < ::Grape::API
    prefix :api
    auth :api_key

    resource :entities_mentions do
      desc 'Find EntitiesMention' do
        security [{ api_key: [] }]
      end

      params do
        requires :url, type: String, desc: 'Mention url'
        requires :entity_id, type: Integer, allow_blank: true, desc: 'Entity id'
      end

      get :find_by_url_and_entity do
        result = Interactors::EntitiesMentions::FindByUrlAndEntity.call(params: params)
        break result.object if result.success?

        error!({ error: result.message }, result.code)
      end
    end
  end
end
