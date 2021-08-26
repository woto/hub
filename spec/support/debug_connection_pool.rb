# frozen_string_literal: true

RSpec.configure do |config|
  config.before do
    puts "Used connections: #{ActiveRecord::Base.connection_pool.connections.count}"
  end
end
