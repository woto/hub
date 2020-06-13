# frozen_string_literal: true

require 'net/http'

module Api
  module V1

    # Processes requests from profile tab page
    class AvatarsController < BaseController
      def show
        if current_user.avatar.attached?
          render json: AvatarSerializer.new(current_user.avatar)
        end
      end

      def update
        current_user.avatar.attach(params[:avatar])
      end
    end
  end
end
