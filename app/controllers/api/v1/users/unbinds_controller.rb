# frozen_string_literal: true

module Api
  module V1
    module Users
      # This class used in oauth authentication process
      class UnbindsController < BaseController
        before_action :doorkeeper_authorize!

        def destroy
          current_user.identities.find_by(provider: params[:id]).destroy
        end
      end
    end
  end
end
