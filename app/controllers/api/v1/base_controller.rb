# frozen_string_literal: true

module Api
  module V1
    # Absolutely all api controllers should inherit from this class!
    class BaseController < ApplicationController
      respond_to :json
      include Pundit
      # after_action :verify_authorized, except: :index
      # after_action :verify_policy_scoped, only: :index

      private

      # https://github.com/doorkeeper-gem/doorkeeper/wiki/Running-Doorkeeper-with-Devise
      def current_resource_owner
        User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end

      # https://github.com/doorkeeper-gem/doorkeeper/wiki/Running-Doorkeeper-with-Devise
      def current_user
        current_resource_owner
      end
    end
  end
end
