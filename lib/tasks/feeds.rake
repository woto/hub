# frozen_string_literal: true

namespace :hub do
  namespace :feeds do
    desc "Sweep freezed feed's jobs"
    task sweep: :environment do
      Import::Sweep.call
    end
  end
end
