namespace :hub do
  desc 'TODO'
  task telegram: :environment do
    TelegramBot.call
  end
end
