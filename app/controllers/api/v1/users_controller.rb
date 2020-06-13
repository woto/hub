# frozen_string_literal: true

module Api
  module V1
    class UsersController < BaseController
      # TODO:
      def show
        render json: UserSerializer.new(current_user)
      end
    end
  end
end
