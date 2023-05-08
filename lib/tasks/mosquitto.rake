# frozen_string_literal: true

require 'mqtt'

namespace :hub do
  desc "Test mosquitto task"
  task mosquitto: :environment do

    puts 'Publishing'

    # Publish example
    MQTT::Client.connect(
      host: ENV.fetch('MOSQUITTO_HOST'),
      port: ENV.fetch('MOSQUITTO_PORT')
    ) do |c|
      puts c.publish('test', 'message')
    end

    puts 'Published'

    puts 'Subscribing'

    # # Subscribe example
    MQTT::Client.connect(
      host: ENV.fetch('MOSQUITTO_HOST'),
      port: ENV.fetch('MOSQUITTO_PORT')
    ) do |c|

      puts 'Subscribed'

      # If you pass a block to the get method, then it will loop
      c.get('test') do |topic, message|
        puts "#{topic}: #{message}"
      end
    end

  end
end
