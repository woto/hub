# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < BaseController
      before_action :doorkeeper_authorize!

      def show
        if current_user.profile
          render json: ProfileSerializer.new(current_user.profile)
        end
      end

      def update
        profile = current_user.profile || current_user.build_profile
        profile.update(profile_params)
      end

      private

      def profile_params
        params.require(:user).permit(:name, :bio, :location, languages: [],
                                                             messengers: %i[name number])
      end
    end
  end
end
