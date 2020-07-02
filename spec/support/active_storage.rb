# frozen_string_literal: true

# TODO: configure it more selectively
# https://relishapp.com/rspec/rspec-core/docs/hooks/filters

RSpec.configure do |config|
  config.before do
    FileUtils.rm_rf(Rails.root.join('tmp', 'storage'))
  end
end
