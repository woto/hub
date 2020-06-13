# frozen_string_literal: true

module Api
  module V1
    # Absolutely all api controllers should inherit from this class!
    class BaseController < ApplicationController
      respond_to :json
      include Pundit
      # after_action :verify_authorized, except: :index
      # after_action :verify_policy_scoped, only: :index
    end
  end
end
