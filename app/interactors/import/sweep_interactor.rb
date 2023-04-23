# frozen_string_literal: true

module Import
  class SweepInteractor
    include ApplicationInteractor

    def call
      workers = Sidekiq::Workers.new
      tids = workers.map { |identity, tid, _work| GlobalHelper.tid_helper(identity, tid) }
      Feed.where.not(locked_by_tid: '').find_each do |feed|
        feed.update(operation: 'sweep', locked_by_tid: '') unless tids.include?(feed.locked_by_tid)
      end
    end
  end
end
