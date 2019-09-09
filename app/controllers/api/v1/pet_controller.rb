# frozen_string_literal: true

module Api
  module V1
    class PetController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :doorkeeper_authorize!

      def create
        render json: current_user
      end

      def show
        current_user
      end
    end
  end
end
