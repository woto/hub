# frozen_string_literal: true

require 'prometheus/client'
require 'prometheus/client/push'

module Prometheus
  class Pusher
    def initialize(pushgateway_address = Rails.configuration.prometheus['pushgateway_address'])
      @pushgateway_address = pushgateway_address
    end

    def metric(metric, type, **args)
      name = "#{metric}_#{type}".tr('.', '_').to_sym
      if registry.exist?(name)
        registry.get(name)
      else
        registry.public_send(type, name, **args)
      end
    end

    def push
      pushgateway.add(registry)
    end

    # # TODO: is it work?
    # def delete
    #   pushgateway.delete
    # end

    private

    def registry
      @registry ||= Prometheus::Client.registry
    end

    def pushgateway
      @pushgateway ||= Prometheus::Client::Push.new('pushgateway', 'instance', @pushgateway_address)
    end
  end
end
