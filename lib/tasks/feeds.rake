# frozen_string_literal: true

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
  end
end
