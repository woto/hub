# frozen_string_literal: true

    class Api::V1::PetController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action do
        # binding.pry
        doorkeeper_authorize!
      end

      def create
        # binding.pry
        render json: current_user
      end

      def show
        # debugger
        current_user
      end
    end
