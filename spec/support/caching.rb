# frozen_string_literal: true

RSpec.configure do |config|
  config.before do
    # TODO: we do not need always cache
    # we can conditionally switch it off
    # https://dev.to/epigene/simple-testing-of-rails-cache-with-rspec-j5
    Rails.cache.clear
  end
end
