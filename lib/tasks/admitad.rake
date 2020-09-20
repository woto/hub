# frozen_string_literal: true

Rails.logger = Logger.new(STDOUT)

namespace :hub do
  namespace :admitad do
    desc 'Sync camapaigns list'
    task sync: :environment do
      context = Networks::Admitad::Token::Restore.call
      context = Networks::Admitad::Token::Retrieve.call if context.failure?
      Networks::Admitad::Sync.call(context)
    end
  end
end
