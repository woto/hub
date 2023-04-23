# frozen_string_literal: true

module API
  class Complains < ::Grape::API
    prefix :api

    resource :complains do

      desc 'Creates new Complain' do
      end

      params do
        requires :text, type: String, documentation: { param_type: 'body' }
        optional :data, type: Hash
      end

      post do
        ::Complains::CreateInteractor.call(params: params, current_user: current_user).object
      end
    end
  end
end
