# frozen_string_literal: true

RSpec.configure do |config|
  config.after do
    Warden.test_reset!
  end
end
