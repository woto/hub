# frozen_string_literal: true

module Import
  class Sweep
    include ApplicationInteractor

    def call
      workers = Sidekiq::Workers.new
      tids = workers.map { |_process_id, tid, _work| tid }
      Feed.where.not(locked_by_tid: '').find_each do |feed|
        feed.update(operation: 'sweep', locked_by_tid: '') unless tids.include?(feed.locked_by_tid)
      end
    end
  end
end
