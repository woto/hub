# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each, :cleanup_feeds) do
    feeds_files = Dir.glob(File.join(Rails.configuration.feeds_path, '*'))
    System.remove_entry(feeds_files)
  end
end
