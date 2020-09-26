# frozen_string_literal: true

Rails.logger = Logger.new(STDOUT)

namespace :hub do
  namespace :gdeslon do
    desc 'Sync advertisers list'
    task sync: :environment do
      Networks::Gdeslon::Sync.call
    end
  end
end
