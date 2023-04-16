# frozen_string_literal: true

module API
  class User < ::Grape::API
    prefix :api
    auth :api_key

    namespace :user do
      desc 'Returns info about authenticated user' do
        security [{ api_key: [] }]
      end

      get :me do
        UserPresenter.call(current_user)
      end

      desc 'Updates user profile'

      params do
        optional :name, type: String, documentation: { param_type: 'body' }
        optional :bio, type: String
        optional :time_zone
        optional :messengers, type: Array do
          optional :type, type: String
          optional :value, type: String
        end
        optional :languages, type: Array[String]
        optional :avatar
      end

      post :change_profile do
        Users::ProfileInteractor.call(params:, current_user:)
        body false
      end

      desc 'Change email'

      params do
        requires :new_email, documentation: { param_type: 'body' }
      end

      post :change_email do
        result = current_user.update_without_password(email: params[:new_email], unconfirmed_email: nil)
        error!({ error: { params: { new_email: current_user.errors[:email] } }.to_json }, 400) unless result
        body false
      end

      desc 'Generates new API key'

      post :regenerate_api_key do
        api_key = current_user.assign_api_key!
        current_user.save!
        api_key
      end

      desc 'Changes user password' do
        security [{ api_key: [] }]
      end

      params do
        requires :new_password, documentation: { param_type: 'body' }
      end

      post :change_password do
        current_user.update(password: params[:new_password])
        warden = request.env['warden']
        warden.session_serializer.store(current_user, :user)
        body false
      end
    end
  end
end
