# frozen_string_literal: true

module Api
  module V1
    class UsersController < BaseController
      before_action :doorkeeper_authorize!
      def show
        render json: UserSerializer.new(current_user)
      end
    end
  end
end
