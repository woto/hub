# frozen_string_literal: true

Rails.logger = Logger.new(STDOUT)

namespace :hub do
  namespace :feeds do
    desc "Set feed's language by quering elastic"
    task language: :environment do
      Feeds::StoreLanguage.call
    end

    desc "Sweep freezed feed's jobs"
    task sweep: :environment do
      Feeds::Sweep.call
    end

    desc 'Download and process feeds'
    task process: :environment do
      Feeds::Process.call
    end
  end
end
