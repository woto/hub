# frozen_string_literal: true

module API
  class Me < ::Grape::API
    prefix :api

    desc 'Returns info about authenticated user'

    get :me do
      current_user
    end
  end
end
