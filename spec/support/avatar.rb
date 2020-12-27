# frozen_string_literal: true

RSpec.configure do |config|
  config.before do
    stub_request(:get, "https://placehold.it/300x300.png").
        to_return(body: file_fixture('avatar.png'), status: 200)
  end
end
