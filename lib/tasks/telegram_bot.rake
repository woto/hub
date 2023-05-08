# frozen_string_literal: true

namespace :hub do
  desc 'Runs telegram bot daemon to handle creation of cites'
  task telegram: :environment do
    TelegramBot::Index.call
  end
end
