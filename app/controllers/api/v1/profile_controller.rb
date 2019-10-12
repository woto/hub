# frozen_string_literal: true

module Api
  module V1
    class ProfileController < BaseController
      before_action :doorkeeper_authorize!

      def create
        # binding.pry
        render json: current_user
      end

      def show
        render json: current_user
      end
    end
  end
end