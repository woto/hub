# frozen_string_literal: true

module API
  class Me < ::Grape::API
    prefix :api
    auth :api_key

    desc 'Returns info about authenticated user' do
      security [{ api_key: [] }]
    end

    get :me do
      current_user
    end
  end
end
