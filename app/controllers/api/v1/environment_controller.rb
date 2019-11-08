# frozen_string_literal: true

require 'net/http'

module Api
  module V1
    # EnvironmentController
    class EnvironmentController < BaseController
      def index
        render json: {
          "environment": Rails.env,
          "time_now": Time.now,
          "current_time": Time.current,
          "remote_ip": request.remote_ip,
          "remote_addr": request.remote_addr,
          "internet_address": Net::HTTP.get(URI.parse('http://checkip.amazonaws.com/')).strip
        }
      end
    end
  end
end
